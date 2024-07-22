local opts = { noremap = true, silent = true }

local map = LazyVim.safe_keymap_set

-- Minus Plus
map("n", "-", "<C-x>", opts)
map("n", "=", "<C-a>", opts)

-- Jump back
map("n", "<C-o>", "<C-o>zz", opts)
map("n", "<C-i>", "<C-i>zz", opts)

-- Do not yank with x
map("n", "x", '"_x', opts)

-- Do not yank with c
map({ "n", "v" }, "c", '"_c', opts)

-- Do not yank with dd
map("n", "dd", '"_dd', opts)
map("n", "vw", "viw", opts)
map("n", "vp", 'viw"_dP', opts)
map("n", "dw", "diw", opts)
map("n", "dW", "diW", opts)
map("n", "yw", "yiw", opts)
map("n", "yW", "yiW", opts)
map("n", "cw", "ciw", opts)
map("n", "cW", "ciW", opts)

--To set in the cursor in the middle when jumping
map({ "n", "v" }, ")", "{", opts)
map({ "n", "v" }, "(", "}", opts)

--To set in the cursor in the middle when jumping
map({ "n", "v" }, "}", "{", opts)
map({ "n", "v" }, "{", "}", opts)
map("n", "N", "Nzz", opts)
map("n", "n", "nzz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "<C-d>", "<C-d>zz", opts)

-- Paste over
map("x", "p", '"_dP', opts)

-- Select all
map("n", "<C-a>", "gg<S-v>G", opts)

-- Faster esc
map("i", "jj", "<cmd>noh<cr><ESC>", opts)
map("i", "kk", "<cmd>noh<cr><ESC>", opts)
map("i", "kj", "<cmd>noh<cr><ESC>", opts)
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", opts)
map("n", "0", "^", opts)

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", opts)

-- Move Lines
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move Down", noremap = true, silent = true })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move Up", noremap = true, silent = true })
map("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move Down", noremap = true, silent = true })
map("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move Up", noremap = true, silent = true })
map("i", "<A-Down>", "<esc>:m .+1<CR>==", { desc = "Move Down", noremap = true, silent = true })
map("i", "<A-Up>", "<esc>:m .-2<CR>==", { desc = "Move Up", noremap = true, silent = true })

-- quit
map("n", "<c-q>", ":qa<cr>", { desc = "Quit all", noremap = true, silent = true })

-- search word under cursor
map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor", noremap = true, silent = true })

-- Buffers
map("n", "<leader>=", "<C-w>=", { desc = "Split Equal" })
map("n", "<leader>\\", "<C-w>v", { desc = "Split window right" })
map("n", "<leader>-", "<C-w>-", { desc = "Split window below" })
map("n", "<leader>B", "<cmd>b#<cr>", { desc = "Previous Buffer" })
map("n", "<leader>C", "<Cmd>BufferLineCloseOthers<CR>", { desc = "Delete Other Buffers" })
map("n", "<leader>D", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window", noremap = true, silent = true })
map(
	"n",
	"<leader>bb",
	"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
	{ desc = "Buffers" }
)
map("n", "<leader>c", LazyVim.ui.bufremove, { desc = "Delete Buffer" })
map("n", "<leader>x", "<cmd>exit<cr>", { desc = "Delete Buffer and Window", noremap = true, silent = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab><s-tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Lazy Stuff

-- toggle options
LazyVim.toggle.map("<leader>uf", LazyVim.toggle.format())
LazyVim.toggle.map("<leader>uF", LazyVim.toggle.format(true))
LazyVim.toggle.map("<leader>us", LazyVim.toggle("spell", { name = "Spelling" }))
LazyVim.toggle.map("<leader>uw", LazyVim.toggle("wrap", { name = "Wrap" }))
LazyVim.toggle.map("<leader>uL", LazyVim.toggle("relativenumber", { name = "Relative Number" }))
LazyVim.toggle.map("<leader>ud", LazyVim.toggle.diagnostics)
LazyVim.toggle.map("<leader>ul", LazyVim.toggle.number)
LazyVim.toggle.map(
	"<leader>uc",
	LazyVim.toggle("conceallevel", { values = { 0, vim.o.conceallevel > 0 and vim.o.conceallevel or 2 } })
)
LazyVim.toggle.map("<leader>uT", LazyVim.toggle.treesitter)
LazyVim.toggle.map("<leader>ub", LazyVim.toggle("background", { values = { "light", "dark" }, name = "Background" }))
if vim.lsp.inlay_hint then
	LazyVim.toggle.map("<leader>uh", LazyVim.toggle.inlay_hints)
end

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos", noremap = true, silent = true })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree", noremap = true, silent = true })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map("n", "<leader><Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height", noremap = true, silent = true })
map("n", "<leader><Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height", noremap = true, silent = true })
map(
	"n",
	"<leader><Left>",
	"<cmd>vertical resize -2<cr>",
	{ desc = "Decrease Window Width", noremap = true, silent = true }
)
map(
	"n",
	"<leader><Right>",
	"<cmd>vertical resize +2<cr>",
	{ desc = "Increase Window Width", noremap = true, silent = true }
)

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch", noremap = true, silent = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result", noremap = true, silent = true })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result", noremap = true, silent = true })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result", noremap = true, silent = true })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result", noremap = true, silent = true })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result", noremap = true, silent = true })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result", noremap = true, silent = true })

-- Add undo break-points
map("i", ",", ",<c-g>u", opts)
map("i", ".", ".<c-g>u", opts)
map("i", ";", ";<c-g>u", opts)

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File", noremap = true, silent = true })

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg", noremap = true, silent = true })

-- better indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy", noremap = true, silent = true })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File", noremap = true, silent = true })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List", noremap = true, silent = true })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List", noremap = true, silent = true })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix", noremap = true, silent = true })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix", noremap = true, silent = true })

-- windows
map("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<c-w>d", "<C-W>c", { desc = "Delete Window", remap = true })

-- lazygit
map("n", "<leader>gg", function()
	LazyVim.lazygit({ cwd = LazyVim.root.git() })
end, { desc = "Lazygit (Root Dir)" })
map("n", "<leader>gG", function()
	LazyVim.lazygit()
end, { desc = "Lazygit (cwd)" })
map("n", "<leader>gb", LazyVim.lazygit.blame_line, { desc = "Git Blame Line" })
map("n", "<leader>gB", LazyVim.lazygit.browse, { desc = "Git Browse" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git Commits" })
map("n", "<leader>go", "<cmd>Telescope git_status<cr>", { desc = "Git Status" })

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- formatting
map({ "n", "v" }, "<leader>w", function()
	LazyVim.format({ force = true })
end, { desc = "Format" })

-- diagnostic
local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end
-- map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "gl", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "gL", diagnostic_goto(false), { desc = "Prev Diagnostic" })
-- map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
-- map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
-- map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
-- map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- -- stylua: ignore start
map("n", "<leader>gf", function()
	local git_path = vim.api.nvim_buf_get_name(0)
	LazyVim.lazygit({ args = { "-f", vim.trim(git_path) } })
end, { desc = "Lazygit Current File History" })

map("n", "<leader>gl", function()
	LazyVim.lazygit({ args = { "log" }, cwd = LazyVim.root.git() })
end, { desc = "Lazygit Log" })
map("n", "<leader>gL", function()
	LazyVim.lazygit({ args = { "log" } })
end, { desc = "Lazygit Log (cwd)" })

-- floating terminal
local lazyterm = function()
	LazyVim.terminal(nil, { cwd = LazyVim.root() })
end
map("n", "<leader>ft", lazyterm, { desc = "Terminal (Root Dir)" })
map("n", "<leader>fT", function()
	LazyVim.terminal()
end, { desc = "Terminal (cwd)" })
map("n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" })
map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })
--
-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
--
--
LazyVim.toggle.map("<c-w>m", LazyVim.toggle.maximize)
--
