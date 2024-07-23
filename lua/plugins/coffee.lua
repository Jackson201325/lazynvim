return {
	recommended = function()
		return LazyVim.extras.wants({
			ft = { "coffee" },
		})
	end,

	{
		"kchmck/vim-coffee-script",
		event = "VeryLazy",
	},
	{
		"williamboman/mason.nvim",
		opts = { ensure_installed = { "coffeesense-language-server" } },
	},

	{
		"neovim/nvim-lspconfig",
		---@class PluginLspOpts
		opts = {
			---@type lspconfig.options
			servers = {
				coffeesense = {
          enable = true,
        },
			},
		},
	},
}
