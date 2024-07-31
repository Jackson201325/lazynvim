return {
	-- file explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		keys = {
			{
				"<leader>fe",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
				end,
				desc = "Explorer NeoTree (Root Dir)",
			},
			{
				"<leader>fE",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
				end,
				desc = "Explorer NeoTree (cwd)",
			},
			{ "<leader>e", "<cmd>Neotree reveal<cr>", desc = "Explorer NeoTree (Root Dir)", remap = true },
			{ "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
			{
				"<leader>ge",
				function()
					require("neo-tree.command").execute({ source = "git_status", toggle = true })
				end,
				desc = "Git Explorer",
			},
			{
				"<leader>be",
				function()
					require("neo-tree.command").execute({ source = "buffers", toggle = true })
				end,
				desc = "Buffer Explorer",
			},
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		init = function()
			-- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
			-- because `cwd` is not set up properly.
			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
				desc = "Start Neo-tree with directory",
				once = true,
				callback = function()
					if package.loaded["neo-tree"] then
						return
					else
						local stats = vim.uv.fs_stat(vim.fn.argv(0))
						if stats and stats.type == "directory" then
							require("neo-tree")
						end
					end
				end,
			})
		end,

		opts = {
			sources = { "filesystem", "buffers", "git_status" },
			open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
			},
			buffers = {
				bind_to_cwd = true,
				follow_current_file = {
					enabled = true,
				}, -- This will find and focus the file in the active buffer every time
				-- the current file is changed while the tree is open.
				group_empty_dirs = true, -- when true, empty directories will be grouped together
				show_unloaded = false, -- When working with sessions, for example, restored but unfocused buffers
				-- are mark as "unloaded". Turn this on to view these unloaded buffer.
				window = {
					mappings = {
						["<bs>"] = "navigate_up",
						["."] = "set_root",
						["bd"] = "buffer_delete",
					},
				},
			},
			window = {
				follow_current_file = true, -- This will find and focus the file in the active buffer every time
				mappings = {
					["<"] = "prev_source",
					[">"] = "next_source",
					["h"] = "close_node",
					["<space>"] = "none",
					["{"] = "next_git_modified",
					["}"] = "prev_git_modified",

					-- ["Y"] = {
					--   function(state)
					--     local node = state.tree:get_node()
					--     local path = node:get_id()
					--     vim.fn.setreg("+", path, "c")
					--   end,
					--   desc = "Copy Path to Clipboard",
					-- },
					["O"] = {
						function(state)
							require("lazy.util").open(state.tree:get_node().path, { system = true })
						end,
						desc = "Open with System Application",
					},
					["P"] = { "toggle_preview", config = { use_float = true } },
					["l"] = "focus_preview",
				},
				position = "float",
				popup = {
					-- settings that apply to float position only
					size = {
						height = "75%",
						width = "30%",
					},
					position = "50%", -- 50% means center it
					-- you can also specify border here, if you want a different setting from
					-- the global popup_border_style.
				},
			},
			popup_border_style = "single", -- "double", "none", "rounded", "shadow", "single" or "solid"
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				git_status = {
					symbols = {
						unstaged = "󰄱",
						staged = "󰱒",
					},
				},
			},
		},

		config = function(_, opts)
			local function on_move(data)
				LazyVim.lsp.on_rename(data.source, data.destination)
			end

			local events = require("neo-tree.events")
			opts.event_handlers = opts.event_handlers or {}
			vim.list_extend(opts.event_handlers, {
				{ event = events.FILE_MOVED, handler = on_move },
				{ event = events.FILE_RENAMED, handler = on_move },
			})
			require("neo-tree").setup(opts)
			vim.api.nvim_create_autocmd("TermClose", {
				pattern = "*lazygit",
				callback = function()
					if package.loaded["neo-tree.sources.git_status"] then
						require("neo-tree.sources.git_status").refresh()
					end
				end,
			})
		end,
	},

	-- search/replace in multiple files
	{
		"MagicDuck/grug-far.nvim",
		opts = { headerMaxWidth = 80 },
		cmd = "GrugFar",
		keys = {
			{
				"<leader>sr",
				function()
					local is_visual = vim.fn.mode():lower():find("v")
					if is_visual then -- needed to make visual selection work
						vim.cmd([[normal! v]])
					end
					local grug = require("grug-far");
					(is_visual and grug.with_visual_selection or grug.grug_far)({
						prefills = { filesFilter = "*." .. vim.fn.expand("%:e") },
					})
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
	},

	-- Flash enhances the built-in search functionality by showing labels
	-- at the end of each match, letting you quickly jump to a specific
	-- location.
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		vscode = true,
		---@type Flash.Config
		opts = {
			labels = "ASDFGHJKLQWERTYUIOPZXCVBNM",
			modes = {
				-- options used when flash is activated through
				-- a regular search with `/` or `?`
				search = {
					-- when `true`, flash will be activated during regular search by default.
					-- You can always toggle when searching with `require("flash").toggle()`
					enabled = true,
					highlight = { backdrop = false },
					jump = { history = true, register = true, nohlsearch = true },
					search = {
						-- `forward` will be automatically set to the search direction
						-- `mode` is always set to `search`
						-- `incremental` is set to `true` when `incsearch` is enabled
					},
				},
				-- options used when flash is activated through
				-- `f`, `F`, `t`, `T`, `;` and `,` motions
				char = {
					enabled = true,
					-- dynamic configuration for ftFT motions
					config = function(opts)
						-- autohide flash when in operator-pending mode
						opts.autohide = vim.fn.mode(true):find("no") and vim.v.operator == "y"

						-- disable jump labels when enabled and when using a count
						opts.jump_labels = opts.jump_labels and vim.v.count == 0

						-- Show jump labels only in operator-pending mode
						-- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
					end,
					-- hide after jump when not using jump labels
					autohide = false,
					-- show jump labels
					jump_labels = true,
					-- set to `false` to use the current line only
					multi_line = true,
					-- When using jump labels, don't use these keys
					-- This allows using those keys directly after the motion
					label = { exclude = "hjkliardc" },
					-- by default all keymaps are enabled, but you can disable some of them,
					-- by removing them from the list.
					-- If you rather use another key, you can map them
					-- to something else, e.g., { [";"] = "L", [","] = H }
					-- keys = { "f", "F", "t", "T", ";", "," },
					keys = { "f", "F", ";", "," },
					---@alias Flash.CharActions table<string, "next" | "prev" | "right" | "left">
					-- The direction for `prev` and `next` is determined by the motion.
					-- `left` and `right` are always left and right.
					char_actions = function(motion)
						return {
							[";"] = "next", -- set to `right` to always go right
							[","] = "prev", -- set to `left` to always go left
							-- clever-f style
							[motion:lower()] = "next",
							[motion:upper()] = "prev",
							-- jump2d style: same case goes next, opposite case goes prev
							-- [motion] = "next",
							-- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
						}
					end,
					search = { wrap = false },
					highlight = { backdrop = true },
					jump = { register = false },
				},
				-- options used for treesitter selections
				-- `require("flash").treesitter()`
				treesitter = {
					labels = "abcdefghijklmnopqrstuvwxyz",
					jump = { pos = "range" },
					search = { incremental = false },
					label = { before = true, after = true, style = "inline" },
					highlight = {
						backdrop = false,
						matches = false,
					},
				},

				treesitter_search = {
					jump = { pos = "range" },
					search = { multi_window = true, wrap = true, incremental = false },
					remote_op = { restore = true },
					label = { before = true, after = true, style = "inline" },
				},
				-- options used for remote flash
				remote = {
					remote_op = { restore = true, motion = true },
				},
			},
		},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      -- { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
	},

	-- which-key helps you remember key bindings by showing a popup
	-- with the active keybindings of the command you started typing.
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts_extend = { "spec" },
		opts = {
			defaults = {},
			spec = {
				{
					mode = { "n", "v" },
					{ "<leader><tab>", group = "tabs" },
					{ "<leader>l", group = "lsp" },
					{ "<leader>f", group = "file/find" },
					{ "<leader>g", group = "git" },
					{ "<leader>gh", group = "hunks" },
					-- { "<leader>q", group = "quit/session" },
					{ "<leader>s", group = "search" },
					{ "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
					{ "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
					{ "[", group = "prev" },
					{ "]", group = "next" },
					{ "g", group = "goto" },
					{ "gs", group = "surround" },
					{ "z", group = "fold" },
					{
						"<leader>b",
						group = "buffer",
						expand = function()
							return require("which-key.extras").expand.buf()
						end,
					},
					-- {
					--   "<c-w>",
					--   group = "windows",
					--   proxy = "<c-w>",
					--   expand = function()
					--     return require("which-key.extras").expand.win()
					--   end,
					-- },
					-- better descriptions
					{ "gx", desc = "Open with system app" },
				},
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Keymaps (which-key)",
			},
			{
				"<c-w><space>",
				function()
					require("which-key").show({ keys = "<c-w>", loop = true })
				end,
				desc = "Window Hydra Mode (which-key)",
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			if not vim.tbl_isempty(opts.defaults) then
				LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
				wk.register(opts.defaults)
			end
		end,
	},

	-- git signs highlights text that has changed since the list
	-- git commit, and also lets you interactively stage & unstage
	-- hunks in a commit.
	{
		"lewis6991/gitsigns.nvim",
		event = "BufRead",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
			},
			signs_staged = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

        -- stylua: ignore start
        map("n", "gh", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "gH", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		},
	},

	-- better diagnostics list and others
	{
		"folke/trouble.nvim",
		cmd = { "Trouble" },
		opts = {
			modes = {
				lsp = {
					win = { position = "right" },
				},
			},
		},
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>ls", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
			{
				"<leader>lS",
				"<cmd>Trouble lsp toggle<cr>",
				desc = "LSP references/definitions/... (Trouble)",
			},
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
			{
				"[[",
				function()
					if require("trouble").is_open() then
						require("trouble").prev({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Previous Trouble/Quickfix Item",
			},
			{
				"]]",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Next Trouble/Quickfix Item",
			},
		},
	},

	-- Finds and lists all of the TODO, HACK, BUG, etc comment
	-- in your project and loads them into a browsable list.
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		opts = {},
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end,              desc = "Next Todo Comment" },
      { "[t",         function() require("todo-comments").jump_prev() end,              desc = "Previous Todo Comment" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                                   desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                                         desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",                 desc = "Todo/Fix/Fixme" },
    },
	},

	-- Toggle Termminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			local status_ok, toggleterm = pcall(require, "toggleterm")
			if not status_ok then
				return
			end

			local terminal = require("toggleterm.terminal").Terminal

			local lazygit = terminal:new({
				cmd = "lazygit",
				dir = "git_dir",
				direction = "float",
				float_opts = {
					border = "none",
				},
				-- function to run on opening the terminal
				on_open = function(term)
					vim.cmd("startinsert!")
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"n",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
				end,
				-- function to run on closing the terminal
				on_close = function()
					vim.cmd("startinsert!")
				end,
			})

			function LAZYGIT_TOGGLE()
				lazygit:toggle()
			end

			local npm_server = terminal:new({
				cmd = "npm run dev",
				close_on_exit = true,
				direction = "float",
				hidden = true,
			})

			function NPM_SERVER_TOGGLE()
				npm_server:toggle()
			end

			local yarn_server = terminal:new({
				cmd = "yarn start",
				close_on_exit = true,
				direction = "float",
				hidden = true,
			})

			function YARN_SERVER_TOGGLE()
				yarn_server:toggle()
			end

			local foreman = terminal:new({
				cmd = "bundle exec foreman start web",
				close_on_exit = true,
				direction = "float",
				hidden = true,
			})

			function RAILS_FOREMAN_TOGGLE()
				foreman:toggle()
			end

			local rails_routes = terminal:new({
				cmd = "bundle exec rails routes",
				close_on_exit = false,
				direction = "float",
			})

			function RAILS_ROUTES_TOGGLE()
				rails_routes:toggle()
			end

			local rails_console = terminal:new({
				cmd = "bundle exec rails c",
				hidden = true,
				direction = "float",
				close_on_exit = true,
			})

			function RAILS_CONSOLE_TOGGLE()
				rails_console:toggle()
			end

			local byebug_server = terminal:new({
				cmd = "bundle exec byebug -R localhost:8989",
				close_on_exit = true,
				direction = "float",
				hidden = true,
			})

			function BYEBUG_SERVER_TOGGLE()
				byebug_server:toggle()
			end

			local rails_server = terminal:new({
				cmd = "bundle exec rails s",
				close_on_exit = false,
				direction = "float",
				hidden = true,
			})

			function RAILS_SERVER_TOGGLE()
				rails_server:toggle()
			end

			local docker_up = terminal:new({
				cmd = "docker-compose up",
				close_on_exit = false,
				direction = "float",
				hidden = true,
				auto_scroll = false,
			})

			function DOCKER_UP_TOGGLE()
				docker_up:toggle()
			end

			local docker_bash = terminal:new({
				cmd = "docker-compose run --rm web bash",
				close_on_exit = false,
				direction = "float",
				hidden = true,
			})

			function DOCKER_BASH_TOGGLE()
				docker_bash:toggle()
			end

			local htop = terminal:new({ direction = "float", cmd = "htop", hidden = true })

			function HTOP_TOGGLE()
				htop:toggle()
			end

			toggleterm.setup({
				size = 20,
				open_mapping = [[<c-t>]],
				hide_numbers = true,
				-- persist_mode = true,
				shade_filetypes = {},
				auto_scroll = false, -- automatically scroll to the bottom on terminal output
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "horizontal",
				close_on_exit = true,
				-- shell = vim.o.shell,
				float_opts = {
					border = "none",
					winblend = 0,
					highlights = {
						border = "normal",
						background = "normal",
					},
				},
			})

			-- Key Mappings
			local map = vim.api.nvim_set_keymap
			local opts = { noremap = true, silent = true }

			map("n", "<leader>rb", "<cmd>lua DOCKER_BASH_TOGGLE()<cr>", opts)
			map("n", "<leader>rd", "<cmd>lua DOCKER_UP_TOGGLE()<cr>", opts)
			map("n", "<leader>rf", "<cmd>lua RAILS_FOREMAN_TOGGLE()<cr>", opts)
			map("n", "<leader>rn", "<cmd>lua NPM_SERVER_TOGGLE()<cr>", opts)
			map("n", "<leader>rrb", "<cmd>lua BYEBUG_SERVER_TOGGLE()<cr>", opts)
			map("n", "<leader>rrc", "<cmd>lua RAILS_CONSOLE_TOGGLE()<cr>", opts)
			map("n", "<leader>rrr", "<cmd>lua RAILS_ROUTES_TOGGLE()<cr>", opts)
			map("n", "<leader>rs", "<cmd>lua RAILS_SERVER_TOGGLE()<cr>", opts)
			map("n", "<leader>ry", "<cmd>lua YARN_SERVER_TOGGLE()<cr>", opts)
		end,
	},

	{
		"cappyzawa/trim.nvim",
		lazy = true,
		config = true,
	},

	{
		"xiyaowong/transparent.nvim",
		lazy = true,
		event = "LazyFile",
		cmd = "TransparentEnable",
		opts = {
			groups = { -- table: default groups
				-- "BqfPreviewBorder",
				-- "BqfPreviewThumb",
				-- "BqfPreviewTitle",
				-- "Comment",
				-- "Conditional",
				-- "Constant",
				-- "EndOfBuffer",
				-- "Float",
				-- "FloatBorder",
				-- "FloatBorderNC",
				-- "Function",
				-- "Identifier",
				-- "LspSagaBorderTitle",
				-- "LspSagaCodeActionBorder",
				-- "LspSagaCodeActionTitle",
				-- "LspSagaFinderSelection",
				-- "LspSagaHoverBorder",
				-- "LspSagaRenameBorder",
				-- "NonText",
				-- "Normal",
				-- "NormalFloat",
				-- "NormalNC",
				-- "Operator",
				-- "PreProc",
				-- "Repeat",
				-- "SignColumn",
				-- "Special",
				-- "Statement",
				-- "String",
				-- "Structure",
				-- "Todo",
				-- "Type",
				"UfoFoldedBg",
				"UfoFoldedFg",
				"UfoPreviewCursorLine",
				"UfoPreviewSbar",
				"UfoPreviewThumb",
			},
			extra_groups = {
				-- "BqfPreviewBorder",
				-- "BqfPreviewThumb",
				-- "BqfPreviewTitle",
				-- "CursorColumn",
				-- "Float",
				-- "FloatBorder",
				-- "FloatBorderNC",
				"Folded",
				-- "LspSagaBorderTitle",
				-- "LspSagaCodeActionBorder",
				-- "LspSagaCodeActionTitle",
				-- "LspSagaFinderSelection",
				-- "LspSagaFinderSelection",
				-- "LspSagaHoverBorder",
				-- "LspSagaHoverBorder",
				-- "LspSagaPreviewBorder",
				-- "LspSagaRenameBorder",
				-- "NeoTreeNormal",
				"lualine_c_normalxxx",
				"lualine_c_normal",
				"lualine_c_inactive",
				"lualine_c_12_insert",
				"lualine_c_12_normal",
				"lualine_c_12_visual",
				"lualine_c_12_command",
				"lualine_c_12_replace",
				"lualine_c_12_inactive",
				"NormalFloat",
				"StatusLine",
				"StatusLineNC",
				-- "TelescopeNormal",
				-- "TelescopePromptBorder",
				"UfoFoldedBg",
				"UfoFoldedFg",
				"UfoPreviewCursorLine",
				"UfoPreviewSbar",
				"UfoPreviewThumb",
				"WhichKey",
				"WhichKeyFloat",
				"ToolbarLine",
			}, -- table: additional groups that should be cleared
			exclude_groups = {}, -- table: groups you don't want to clear
		},
		config = function(_, opts)
			require("transparent").setup(opts)
		end,
	},

	{
		"mbbill/undotree",
		config = true,
		keys = {
			{ "<leader>U", "<cmd>UndotreeToggle<CR>", desc = "Undo tree" },
		},
	},

	{
		import = "plugins.extras.editor.telescope",
		enabled = function()
			return LazyVim.pick.want() == "telescope"
		end,
	},

	{
		"Wansmer/treesj",
    lazy = true,
		dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
		config = function()
			require("treesj").setup({})
		end,
	},
}
