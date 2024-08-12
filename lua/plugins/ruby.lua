if lazyvim_docs then
	-- LSP Server to use for Ruby.
	-- Set to "solargraph" to use solargraph instead of ruby_lsp.
	vim.g.lazyvim_ruby_lsp = "solargraph"
	vim.g.lazyvim_ruby_formatter = "rubocop"
end

local lsp = vim.g.lazyvim_ruby_lsp or "ruby_lsp"

if vim.fn.has("nvim-0.10") == 0 then
	-- ruby_lsp does not work well with Neovim < 0.10
	lsp = vim.g.lazyvim_ruby_lsp or "solargraph"
end
-- local formatter = vim.g.lazyvim_ruby_formatter or "rubocop"

return {
	recommended = function()
		return LazyVim.extras.wants({
			ft = "ruby",
			root = "Gemfile",
		})
	end,
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "ruby" } },
	},
	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			---@type lspconfig.options
			servers = {
				-- ruby_lsp = {
				-- 	enabled = true,
				-- },
				solargraph = {
					enabled = true,
					settings = {
						solargraph = {
							diagnostics = true,
							formatting = false,
							signature_help = false,
						},
					},
				},
				-- rubocop = {
				-- 	enabled = true,
				-- },
				-- standardrb = {
				-- 	enabled = formatter == "standardrb",
				-- },
			},
			setup = {},
		},
	},
	{
		"williamboman/mason.nvim",
		opts = { ensure_installed = { "erb-formatter", "erb-lint" } },
	},
	-- {
	-- 	"mfussenegger/nvim-dap",
	-- 	optional = true,
	-- 	dependencies = {
	-- 		"suketa/nvim-dap-ruby",
	-- 		config = function()
	-- 			require("dap-ruby").setup()
	-- 		end,
	-- 	},
	-- },
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				ruby = { "rubocop" },
				eruby = { "erb_format" },
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = {
			linters_by_ft = {
				-- ruby = { "rubocop" },
				eruby = { "erb_lint" },
			},
		},
	},
	-- {
	-- 	"nvim-neotest/neotest",
	-- 	optional = true,
	-- 	dependencies = {
	-- 		"olimorris/neotest-rspec",
	-- 	},
	-- 	opts = {
	-- 		adapters = {
	-- 			["neotest-rspec"] = {
	-- 				-- NOTE: By default neotest-rspec uses the system wide rspec gem instead of the one through bundler
	-- 				-- rspec_cmd = function()
	-- 				--   return vim.tbl_flatten({
	-- 				--     "bundle",
	-- 				--     "exec",
	-- 				--     "rspec",
	-- 				--   })
	-- 				-- end,
	-- 			},
	-- 		},
	-- 	},
	-- },
}
