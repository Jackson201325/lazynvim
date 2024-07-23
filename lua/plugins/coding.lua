local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = (" 󰁂 %d "):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, "MoreMsg" })
	return newVirtText
end

return {
	-- auto completion
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		lazy = true,
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		-- Not all LSP servers add brackets when completing a function.
		-- To better deal with this, LazyVim adds a custom option to cmp,
		-- that you can configure. For example:
		--
		-- ```lua
		-- opts = {
		--   auto_brackets = { "python" }
		-- }
		-- ```
		opts = function()
			vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
			local cmp = require("cmp")
			local defaults = require("cmp.config.default")()
			local auto_select = true
      local types = require('cmp.types')

			return {
				auto_brackets = {}, -- configure any filetype to auto add brackets
				completion = {
					completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
				},
				preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
					["<C-k>"] = cmp.mapping({
						i = function()
							if cmp.visible() then
								cmp.abort()
							else
								cmp.complete()
							end
						end,
					}),

					["<Tab>"] = {
						i = function()
							if cmp.visible() then
								cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
							else
								cmp.complete()
							end
						end,
					},
					["<S-Tab>"] = {
						i = function()
							if cmp.visible() then
								cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })
							else
								cmp.complete()
							end
						end,
					},
					["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
					["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<C-CR>"] = function(fallback)
						cmp.abort()
						fallback()
					end,
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
				formatting = {
					pandable_indicator = true,
					fields = { "abbr", "kind", "menu" },
					format = function(_, item)
						local icons = LazyVim.config.icons.kinds
						if icons[item.kind] then
							item.kind = icons[item.kind] .. item.kind
						end

						local widths = {
							abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
							menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
						}

						for key, width in pairs(widths) do
							if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
								item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
							end
						end

						return item
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				experimental = {
					ghost_text = {
						hl_group = "CmpGhostText",
					},
				},
				sorting = defaults.sorting,
			}
		end,
		main = "util.cmp",
	},

	-- snippets
	{
		"nvim-cmp",
		dependencies = {
			{
				"garymjr/nvim-snippets",
				opts = {
					friendly_snippets = true,
				},
				dependencies = { "rafamadriz/friendly-snippets" },
			},
		},
		opts = function(_, opts)
			opts.snippet = {
				expand = function(item)
					return LazyVim.cmp.expand(item.body)
				end,
			}
			if LazyVim.has("nvim-snippets") then
				table.insert(opts.sources, { name = "snippets" })
			end
		end,
		keys = {
			{
				"<Tab>",
				function()
					return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
				end,
				expr = true,
				silent = true,
				mode = { "i", "s" },
			},
			{
				"<S-Tab>",
				function()
					return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
				end,
				expr = true,
				silent = true,
				mode = { "i", "s" },
			},
		},
	},

	-- auto pairs
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {
			modes = { insert = true, command = true, terminal = false },
			-- skip autopair when next character is one of these
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			-- skip autopair when the cursor is inside these treesitter nodes
			skip_ts = { "string" },
			-- skip autopair when next character is closing pair
			-- and there are more closing pairs than opening pairs
			skip_unbalanced = true,
			-- better deal with markdown code blocks
			markdown = true,
		},
		config = function(_, opts)
			LazyVim.mini.pairs(opts)
		end,
	},

	-- comments
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- ys actions
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "InsertEnter",
		opts = {},
	},

	-- ys actions
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		lazy = true,
		event = "VeryLazy",
		opts = {
			open_fold_hl_timeout = 150,
			close_fold_kinds = {},
			preview = {
				win_config = {
					border = { "", "─", "", "", "", "─", "", "" },
					winhighlight = "Normal:Folded",
					winblend = 0,
				},
				mappings = {
					scrollU = "<C-u>",
					scrollD = "<C-d>",
					jumpTop = "[",
					jumpBot = "]",
				},
			},
			fold_virt_text_handler = handler,
			provider_selector = function(bufnr, filetype, buftype)
				-- if you prefer treesitter provider rather than lsp,
				-- return ftMap[filetype] or {'treesitter', 'indent'}
				-- return ftMap[filetype]
				return { "lsp", "indent" }
			end,
			enable_get_fold_virt_text = true,
		},
		keys = {
			{
				"zr",
				function()
					require("ufo").openFoldsExceptKinds()
				end,
				mode = { "n", "v" },
				desc = "Fold less",
			},
			{
				"zR",
				function()
					require("ufo").openAllFolds()
				end,
				mode = { "n", "v" },
				desc = "Open All Folds",
			},
			{
				"zm",
				function()
					require("ufo").closeFoldsWith()
				end,
				mode = { "n", "v" },
				desc = "Fold more",
			},
			{
				"zM",
				function()
					require("ufo").closeAllFolds()
				end,
				mode = { "n", "v" },
				desc = "Close All Folds",
			},
		},
	},

	-- Better text-objects
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ -- code block
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
					d = { "%f[%d]%d+" }, -- digits
					e = { -- Word with case
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[%S][%l%d]+%f[^%l%d]",
							"%f[%P][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
						},
						"^().*()$",
					},
					i = LazyVim.mini.ai_indent, -- indent
					g = LazyVim.mini.ai_buffer, -- buffer
					u = ai.gen_spec.function_call(), -- u for "Usage"
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
			LazyVim.on_load("which-key.nvim", function()
				vim.schedule(function()
					LazyVim.mini.ai_whichkey(opts)
				end)
			end)
		end,
	},

	{
		"mg979/vim-visual-multi",
		branch = "master",
		event = "LazyFile",
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
				{ path = "LazyVim", words = { "LazyVim" } },
				{ path = "lazy.nvim", words = { "LazyVim" } },
			},
		},
	},
	-- Manage libuv types with lazy. Plugin will never be loaded
	{ "Bilal2453/luvit-meta", lazy = true },
	-- Add lazydev source to cmp
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			table.insert(opts.sources, { name = "lazydev", group_index = 0 })
		end,
	},
}
