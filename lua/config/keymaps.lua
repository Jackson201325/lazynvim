local keymap = vim.keymap
local opts = { noremap = true, silent = true }
--
-- -- Minus Plus
keymap.set("n", "-", "<C-x>", opts)
keymap.set("n", "=", "<C-a>", opts)

-- Jump back
keymap.set("n", "<C-o>", "<C-o>zz", opts)
keymap.set("n", "<C-i>", "<C-i>zz", opts)

-- Do not yank with x
keymap.set("n", "x", '"_x', opts)

-- Do not yank with c
keymap.set({ "n", "v" }, "c", '"_c', opts)

-- Do not yank with dd
keymap.set("n", "dd", '"_dd', opts)
--
keymap.set({ "n" }, "vw", "viw")
keymap.set({ "n" }, "vp", 'viw"_dP')
--
keymap.set({ "n" }, "dw", "diw")
keymap.set({ "n" }, "dW", "diW")

keymap.set({ "n" }, "yw", "yiw")
keymap.set({ "n" }, "yW", "yiW")

keymap.set({ "n" }, "cw", "ciw")
keymap.set({ "n" }, "cW", "ciW")

-- --To set in the cursor in the middle when jumping
-- keymap.set("n", "(", "{zz", opts)
-- keymap.set("n", ")", "}zz", opts)

--To set in the cursor in the middle when jumping
keymap.set({ "n", "v" }, ")", "{", opts)
keymap.set({ "n", "v" }, "(", "}", opts)

--To set in the cursor in the middle when jumping
keymap.set({ "n", "v" }, "}", "{", opts)
keymap.set({ "n", "v" }, "{", "}", opts)

keymap.set("n", "N", "Nzz", opts)
keymap.set("n", "n", "nzz", opts)

keymap.set("n", "<C-u>", "<C-u>zz", opts)
keymap.set("n", "<C-d>", "<C-d>zz", opts)
-- Paste over
keymap.set("x", "p", '"_dP', opts)

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", opts)

-- Move Lines
keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- save file
keymap.set({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", opts)

-- quit
keymap.set("n", "<c-q>", ":qa<cr>", { desc = "Quit all" })

-- Faster esc
keymap.set("i", "jj", "<cmd>noh<cr><ESC>", opts)
keymap.set("i", "kk", "<cmd>noh<cr><ESC>", opts)
keymap.set("i", "kj", "<cmd>noh<cr><ESC>", opts)
keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", opts)

keymap.set("n", "0", "^", opts)

-- Move to window using the <ctrl> hjkl keys
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", noremap = true, silent = true })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", noremap = true, silent = true })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", noremap = true, silent = true })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", noremap = true, silent = true })

-- better indenting
keymap.set("v", ">", ">gv", opts)
keymap.set("v", "<", "<gv", opts)

-- search word under cursor
keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor", noremap = true, silent = true })

-- move
keymap.set("n", "<S-h>", ":bprevious<cr>", { desc = "Prev buffer", noremap = true, silent = true })
keymap.set("n", "<S-l>", ":bnext<cr>", { desc = "Next buffer", noremap = true, silent = true })

-- Lazy Stuff

-- highlights under cursor
keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
keymap.set("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- better up/down
keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

keymap.set("n", "<leader><Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
keymap.set("n", "<leader><Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
keymap.set("n", "<leader><Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
keymap.set("n", "<leader><Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- buffers
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<leader>d", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
keymap.set("n", "<leader>c", "<cmd>lua require('mini.bufremove').delete(0, false)<CR>",
  { desc = "Delete Buffer and Window" })

-- Clear search with <esc>
keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
keymap.set("i", ",", ",<c-g>u")
keymap.set("i", ".", ".<c-g>u")
keymap.set("i", ";", ";<c-g>u")

-- save file
keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

--keywordprg
keymap.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- lazy
keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- windows
keymap.set("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
keymap.set("n", "<c-w>d", "<C-W>c", { desc = "Delete Window", remap = true })
--
-- -- commenting
-- -- keymap.set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
-- -- map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
--
-- -- Clear search, diff update and redraw
-- -- taken from runtime/lua/_editor.lua
-- -- map(
-- --   "n",
-- --   "<leader>ur",
-- --   "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
-- --   { desc = "Redraw / Clear hlsearch / Diff Update" }
-- -- )
--
--
-- -- formatting
-- -- map({ "n", "v" }, "<leader>cf", function()
-- --   LazyVim.format({ force = true })
-- -- end, { desc = "Format" })
--
-- -- diagnostic
-- -- local diagnostic_goto = function(next, severity)
-- --   local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
-- --   severity = severity and vim.diagnostic.severity[severity] or nil
-- --   return function()
-- --     go({ severity = severity })
-- --   end
-- -- end
-- -- map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
-- -- map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
-- -- map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
-- -- map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
-- -- map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
-- -- map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
-- -- map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
--
-- -- stylua: ignore start
--
-- -- toggle options
-- -- LazyVim.toggle.map("<leader>uf", LazyVim.toggle.format())
-- -- LazyVim.toggle.map("<leader>uF", LazyVim.toggle.format(true))
-- -- LazyVim.toggle.map("<leader>us", LazyVim.toggle("spell", { name = "Spelling" }))
-- -- LazyVim.toggle.map("<leader>uw", LazyVim.toggle("wrap", { name = "Wrap" }))
-- -- LazyVim.toggle.map("<leader>uL", LazyVim.toggle("relativenumber", { name = "Relative Number" }))
-- -- LazyVim.toggle.map("<leader>ud", LazyVim.toggle.diagnostics)
-- -- LazyVim.toggle.map("<leader>ul", LazyVim.toggle.number)
-- -- LazyVim.toggle.map( "<leader>uc", LazyVim.toggle("conceallevel", { values = { 0, vim.o.conceallevel > 0 and vim.o.conceallevel or 2 } }))
-- -- LazyVim.toggle.map("<leader>uT", LazyVim.toggle.treesitter)
-- -- LazyVim.toggle.map("<leader>ub", LazyVim.toggle("background", { values = { "light", "dark" }, name = "Background" }))
-- -- if vim.lsp.inlay_hint then
-- --   LazyVim.toggle.map("<leader>uh", LazyVim.toggle.inlay_hints)
-- -- end
--
-- -- lazygit
-- -- map("n", "<leader>gg", function() LazyVim.lazygit( { cwd = LazyVim.root.git() }) end, { desc = "Lazygit (Root Dir)" })
-- -- map("n", "<leader>gG", function() LazyVim.lazygit() end, { desc = "Lazygit (cwd)" })
-- -- map("n", "<leader>gb", LazyVim.lazygit.blame_line, { desc = "Git Blame Line" })
-- -- map("n", "<leader>gB", LazyVim.lazygit.browse, { desc = "Git Browse" })
--
-- -- map("n", "<leader>gf", function()
-- --   local git_path = vim.api.nvim_buf_get_name(0)
-- --   LazyVim.lazygit({args = { "-f", vim.trim(git_path) }})
-- -- end, { desc = "Lazygit Current File History" })
--
-- -- map("n", "<leader>gl", function()
-- --   LazyVim.lazygit({ args = { "log" }, cwd = LazyVim.root.git() })
-- -- end, { desc = "Lazygit Log" })
-- -- map("n", "<leader>gL", function()
-- --   LazyVim.lazygit({ args = { "log" } })
-- -- end, { desc = "Lazygit Log (cwd)" })
--
--
-- -- LazyVim Changelog
-- -- map("n", "<leader>L", function() LazyVim.news.changelog() end, { desc = "LazyVim Changelog" })
--
-- -- floating terminal
-- -- local lazyterm = function() LazyVim.terminal(nil, { cwd = LazyVim.root() }) end
-- -- map("n", "<leader>ft", lazyterm, { desc = "Terminal (Root Dir)" })
-- -- map("n", "<leader>fT", function() LazyVim.terminal() end, { desc = "Terminal (cwd)" })
-- -- map("n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" })
-- -- map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })
--
-- -- Terminal Mappings
-- -- map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
-- -- map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
-- -- map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
-- -- map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
-- -- map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
-- -- map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- -- map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
--
--
-- -- LazyVim.toggle.map("<c-w>m", LazyVim.toggle.maximize)
--
-- -- tabs
-- -- map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- -- map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
-- -- map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- -- map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- -- map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- -- map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
-- -- map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
