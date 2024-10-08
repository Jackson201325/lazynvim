return {

	-- Session management. This saves your session in the background,
	-- keeping track of open buffers, window arrangement, and more.
	-- You can restore sessions when returning through the dashboard.
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
    -- stylua: ignore
    keys = {
      -- { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      -- { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      -- { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },
	},

	-- library used by other plugins
	{ "nvim-lua/plenary.nvim", lazy = true },
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		lazy = false,
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
}
