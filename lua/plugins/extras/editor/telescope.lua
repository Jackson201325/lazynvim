if lazyvim_docs then
	-- In case you don't want to use `:LazyExtras`,
	-- then you need to set the option below.
	vim.g.lazyvim_picker = "telescope"
end

-- local live_grep_args = require("telescope-live-grep-args")
-- local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

local have_make = vim.fn.executable("make") == 1
local have_cmake = vim.fn.executable("cmake") == 1

---@type LazyPicker
local picker = {
	name = "telescope",
	commands = {
		files = "find_files",
	},
	-- this will return a function that calls telescope.
	-- cwd will default to util.get_root
	-- for `files`, git_files or find_files will be chosen depending on .git
	---@param builtin string
	---@param opts? util.pick.Opts
	open = function(builtin, opts)
		opts = opts or {}
		opts.follow = opts.follow ~= false
		if opts.cwd and opts.cwd ~= vim.uv.cwd() then
			local function open_cwd_dir()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				LazyVim.pick.open(
					builtin,
					vim.tbl_deep_extend("force", {}, opts or {}, {
						root = false,
						default_text = line,
					})
				)
			end
			---@diagnostic disable-next-line: inject-field
			opts.attach_mappings = function(_, map)
				-- opts.desc is overridden by telescope, until it's changed there is this fix
				map("i", "<a-c>", open_cwd_dir, { desc = "Open cwd Directory" })
				return true
			end
		end

		require("telescope.builtin")[builtin](opts)
	end,
}
if not LazyVim.pick.register(picker) then
	return {}
end

return {
	-- Fuzzy finder.
	-- The default key bindings to find files will use Telescope's
	-- `find_files` or `git_files` depending on whether the
	-- directory is a git repo.
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		enabled = function()
			return LazyVim.pick.want() == "telescope"
		end,
		version = false, -- telescope did only one release, so use HEAD for now
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = have_make and "make"
					or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				enabled = have_make or have_cmake,
				config = function(plugin)
					LazyVim.on_load("telescope.nvim", function()
						local ok, err = pcall(require("telescope").load_extension, "fzf")
						if not ok then
							local lib = plugin.dir .. "/build/libfzf." .. (LazyVim.is_win() and "dll" or "so")
							if not vim.uv.fs_stat(lib) then
								LazyVim.warn("`telescope-fzf-native.nvim` not built. Rebuilding...")
								require("lazy").build({ plugins = { plugin }, show = false }):wait(function()
									LazyVim.info("Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim.")
								end)
							else
								LazyVim.error("Failed to load `telescope-fzf-native.nvim`:\n" .. err)
							end
						end
					end)
				end,
			},
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
		},
		keys = {
			{
				"<leader>.",
				":Telescope file_browser path=%:p:h select_buffer=true<CR>",
				desc = "Switch Buffer",
			},
			{
				"<leader>,",
				"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Switch Buffer",
			},
			{
				"<leader>/",
				"<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args({})<CR>",
				-- LazyVim.pick("live_grep"),
				desc = "Grep (Root Dir)",
			},
			{
				"<leader>:",
				"<cmd>Telescope command_history<cr>",
				desc = "Command History",
			},
			{
				"<leader><space>",
				LazyVim.pick("files"),
				desc = "Find Files (Root Dir)",
			},
			-- find
			{
				"<leader>F",
				"<cmd>lua require('telescope.builtin').find_files({no_ignore = true})<cr>",
				desc = "Hidden Files",
			},
			{
				"<leader>fb",
				"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Buffers",
			},
			{
				"<leader>fc",
				LazyVim.pick.config_files(),
				desc = "Find Config File",
			},
			{
				"<leader>ff",
				LazyVim.pick("files"),
				desc = "Find Files (Root Dir)",
			},
			{
				"<leader>fF",
				LazyVim.pick("files", { root = false }),
				desc = "Find Files (cwd)",
			},
			{
				"<leader>fg",
				"<cmd>Telescope git_files<cr>",
				desc = "Find Files (git-files)",
			},
			{
				"<leader>gb",
				"<cmd>Telescope git_branches<cr>",
				desc = "Find branches (git-branches)",
			},
			{
				"<leader>fB",
				"<cmd>Telescope file_browser<cr>",
				desc = "File Browser",
			},

			{
				"<leader>fr",
				LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }),
				desc = "Recent (cwd)",
			},
			-- { "<leader>fr",      "<cmd>Telescope oldfiles<cr>",                                    desc = "Recent" },
			-- search
			{
				'<leader>s"',
				"<cmd>Telescope registers<cr>",
				desc = "Registers",
			},
			{
				"<leader>sa",
				"<cmd>Telescope autocommands<cr>",
				desc = "Auto Commands",
			},
			{
				"<leader>sb",
				"<cmd>Telescope current_buffer_fuzzy_find<cr>",
				desc = "Buffer",
			},
			{
				"<leader>sc",
				"<cmd>Telescope command_history<cr>",
				desc = "Command History",
			},
			{
				"<leader>sC",
				"<cmd>Telescope commands<cr>",
				desc = "Commands",
			},
			{
				"<leader>sd",
				"<cmd>Telescope diagnostics bufnr=0<cr>",
				desc = "Document Diagnostics",
			},
			{
				"<leader>sD",
				"<cmd>Telescope diagnostics<cr>",
				desc = "Workspace Diagnostics",
			},
			{
				"<leader>sg",
				LazyVim.pick("live_grep"),
				desc = "Grep (Root Dir)",
			},
			{
				"<leader>sG",
				LazyVim.pick("live_grep", { root = false }),
				desc = "Grep (cwd)",
			},
			{
				"<leader>sh",
				"<cmd>Telescope help_tags<cr>",
				desc = "Help Pages",
			},
			{
				"<leader>sH",
				"<cmd>Telescope highlights<cr>",
				desc = "Search Highlight Groups",
			},
			{
				"<leader>sj",
				"<cmd>Telescope jumplist<cr>",
				desc = "Jumplist",
			},
			{
				"<leader>sk",
				"<cmd>Telescope keymaps<cr>",
				desc = "Key Maps",
			},
			{
				"<leader>sl",
				"<cmd>Telescope loclist<cr>",
				desc = "Location List",
			},
			{
				"<leader>sM",
				"<cmd>Telescope man_pages<cr>",
				desc = "Man Pages",
			},
			{
				"<leader>sm",
				"<cmd>Telescope marks<cr>",
				desc = "Jump to Mark",
			},
			{
				"<leader>so",
				"<cmd>Telescope vim_options<cr>",
				desc = "Options",
			},
			{
				"<leader>sR",
				"<cmd>Telescope resume<cr>",
				desc = "Resume",
			},
			{
				"<leader>sq",
				"<cmd>Telescope quickfix<cr>",
				desc = "Quickfix List",
			},
			{
				"<leader>sw",
				LazyVim.pick("grep_string", { word_match = "-w" }),
				desc = "Word (Root Dir)",
			},
			{
				"<leader>sW",
				LazyVim.pick("grep_string", { root = false, word_match = "-w" }),
				desc = "Word (cwd)",
			},
			{
				"<leader>sw",
				LazyVim.pick("grep_string"),
				mode = "v",
				desc = "Selection (Root Dir)",
			},
			{
				"<leader>sW",
				LazyVim.pick("grep_string", { root = false }),
				mode = "v",
				desc = "Selection (cwd)",
			},
			{
				"<leader>uC",
				LazyVim.pick("colorscheme", { enable_preview = true }),
				desc = "Colorscheme with Preview",
			},
			{
				"<leader>ss",
				function()
					require("telescope.builtin").lsp_document_symbols({
						symbols = LazyVim.config.get_kind_filter(),
					})
				end,
				desc = "Goto Symbol",
			},
			{
				"<leader>sS",
				function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols({
						symbols = LazyVim.config.get_kind_filter(),
					})
				end,
				desc = "Goto Symbol (Workspace)",
			},
		},
		opts = function()
			local actions = require("telescope.actions")
			local lga_actions = require("telescope-live-grep-args.actions")

			local open_with_trouble = function(...)
				return require("trouble.sources.telescope").open(...)
			end
			local find_files_no_ignore = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				LazyVim.pick("find_files", { no_ignore = true, default_text = line })()
			end
			local find_files_with_hidden = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				LazyVim.pick("find_files", { hidden = true, default_text = line })()
			end

			local function find_command()
				if 1 == vim.fn.executable("rg") then
					return { "rg", "--files", "--color", "never", "-g", "!.git" }
				elseif 1 == vim.fn.executable("fd") then
					return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
				elseif 1 == vim.fn.executable("fdfind") then
					return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
				elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
					return { "find", ".", "-type", "f" }
				elseif 1 == vim.fn.executable("where") then
					return { "where", "/r", ".", "*" }
				end
			end

			return {
				defaults = {
					sorting_strategy = "ascending",
					initial_mode = "insert",
					layout_config = {
						prompt_position = "top",
						horizontal = {
							width_padding = 0.1,
							height_padding = 0.1,
							preview_width = 0.6, -- Adjust this value to make the preview window wider
						},
						vertical = {
							width_padding = 0.05,
							height_padding = 1,
							preview_height = 0.5, -- Adjust this value to make the preview window taller
						},
					},
					prompt_prefix = " ",
					selection_caret = " ",
					-- open files in the first window that is an actual file.
					-- use the current window if no other window is available.
					get_selection_window = function()
						local wins = vim.api.nvim_list_wins()
						table.insert(wins, 1, vim.api.nvim_get_current_win())
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].buftype == "" then
								return win
							end
						end
						return 0
					end,
					mappings = {
						i = {
							["<c-t>"] = open_with_trouble,
							["<a-t>"] = open_with_trouble,
							["<c-i>"] = find_files_no_ignore,
							["<c-h>"] = find_files_with_hidden,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-l>"] = actions.send_selected_to_loclist + actions.open_loclist,

							["<C-Down>"] = actions.cycle_history_next,
							["<C-Up>"] = actions.cycle_history_prev,
							["<C-f>"] = actions.preview_scrolling_down,
							["<C-b>"] = actions.preview_scrolling_up,
							["<C-k>"] = lga_actions.quote_prompt({
								postfix = " --iglob !**/*_spec.rb --iglob !spec/** --iglob !**/**test**/** --iglob !**/**.yml",
							}),
						},
						n = {
							["q"] = actions.close,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-l>"] = actions.send_selected_to_loclist + actions.open_loclist,
						},
					},
				},
				pickers = {
					find_files = {
						find_command = find_command,
						hidden = true,
					},
				},
			}
		end,
		extensions = {
			file_browser = {
				theme = "ivy",
				-- disables netrw and use telescope-file-browser in its place
				hijack_netrw = true,
				mappings = {},
			},
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				-- the default case_mode is "smart_case"
			},
		},
	},

	-- Flash Telescope config
	{
		"nvim-telescope/telescope.nvim",
		optional = true,
		opts = function(_, opts)
			if not LazyVim.has("flash.nvim") then
				return
			end
			local function flash(prompt_bufnr)
				require("flash").jump({
					pattern = "^",
					label = { after = { 0, 0 } },
					search = {
						mode = "search",
						exclude = {
							function(win)
								return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
							end,
						},
					},
					action = function(match)
						local picker_action = require("telescope.actions.state").get_current_picker(prompt_bufnr)
						picker_action:set_selection(match.pos[1] - 1)
					end,
				})
			end
			opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
				mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
			})
		end,
	},

	-- better vim.ui with telescope
	{
		"stevearc/dressing.nvim",
		lazy = true,
		-- enabled = function()
		-- 	return LazyVim.pick.want() == "telescope"
		-- end,
		event = "VeryLazy",
		enabled = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},

	{
		"neovim/nvim-lspconfig",
		opts = function()
			if LazyVim.pick.want() ~= "telescope" then
				return
			end
			local Keys = require("plugins.lsp.keymaps").get()
      -- stylua: ignore
      vim.list_extend(Keys, {
        -- { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end,      desc = "Goto Definition",       has = "definition" },
        { "gr", "<cmd>Telescope lsp_references<cr>",                                                    desc = "References",            nowait = true },
        { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end,  desc = "Goto Implementation" },
        { "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
      })
		end,
	},

	--lazy
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		lazy = true,
		event = "VeryLazy",
	},
}
