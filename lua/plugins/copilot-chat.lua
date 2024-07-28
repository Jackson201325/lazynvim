local M = {}

---@param kind string
function M.pick(kind)
	return function()
		local actions = require("CopilotChat.actions")
		local items = actions[kind .. "_actions"]()
		if not items then
			LazyVim.warn("No " .. kind .. " found on the current line")
			return
		end
		local ok = pcall(require, "fzf-lua")
		require("CopilotChat.integrations." .. (ok and "fzflua" or "telescope")).pick(items)
	end
end

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		cmd = "CopilotChat",
		opts = function()
			local user = vim.env.USER or "User"
			user = user:sub(1, 1):upper() .. user:sub(2)
			return {
				model = "gpt-4",
				mappings = {
					reset = {
						normal = "<C-x>",
						insert = "<C-x>",
					},
				},
				auto_insert_mode = true,
				show_help = true,
				question_header = "  " .. user .. " ",
				answer_header = "  Copilot ",
				-- default window options
				window = {
					layout = "horizontal", -- 'vertical', 'horizontal', 'float', 'replace'
					width = 0.18, -- fractional width of parent, or absolute width in columns when > 1
					height = 0.3, -- fractional height of parent, or absolute height in rows when > 1
					-- Options below only apply to floating windows
					relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
					border = "single", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
					-- row = nil, -- row position of the window, default is centered
					-- col = nil, -- column position of the window, default is centered
					title = "Copilot Chat", -- title of chat window
					-- footer = nil, -- footer of chat window
					zindex = 1, -- determines if window is on top or below other floating windows
				},
				selection = function(source)
					local select = require("CopilotChat.select")
					return select.visual(source) or select.buffer(source)
				end,
			}
		end,
		keys = {
			{ "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{
				"<leader>aa",
				function()
					return require("CopilotChat").toggle()
				end,
				desc = "Toggle (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>ax",
				function()
					return require("CopilotChat").reset()
				end,
				desc = "Clear (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>ai",
				":CopilotChatInline<cr>",
				mode = { "n", "v" },
				desc = "CopilotChat - Inline chat",
			},
			{
				"<leader>aq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input)
					end
				end,
				desc = "Quick Chat (CopilotChat)",
				mode = { "n", "v" },
			},
			-- Show help actions with telescope
			{ "<leader>ad", M.pick("help"), desc = "Diagnostic Help (CopilotChat)", mode = { "n", "v" } },
			-- Show prompts actions with telescope
			{ "<leader>ap", M.pick("prompt"), desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			local select = require("CopilotChat.select")

			require("CopilotChat.integrations.cmp").setup()

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-chat",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
				end,
			})

			chat.setup(opts)

			vim.api.nvim_create_user_command("CopilotChatInline", function(args)
				chat.ask(args.args, {
					selection = select.visual,
					window = {
						layout = "float",
						relative = "cursor",
						width = 0.6,
						height = 0.5,
						row = 1,
					},
				})
			end, { nargs = "*", range = true })
		end,
	},

	-- Edgy integration
	-- {
	-- 	"folke/edgy.nvim",
	-- 	optional = true,
	-- 	opts = function(_, opts)
	-- 		opts.bottom = opts.bottom or {}
	-- 		table.insert(opts.bottom, {
	-- 			ft = "copilot-chat",
	-- 			title = "Copilot Chat",
	-- 			size = { height = 0.35 },
	-- 		})
	-- 	end,
	-- },
}
