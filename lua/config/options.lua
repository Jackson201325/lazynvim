local opt = vim.opt

-- line numbers
opt.number = true         -- Print line number
opt.relativenumber = true -- Relative line numbers
-- opt.colorcolumn = "80"    -- Add a color column at 80 characters

-- tabs & indentation
opt.list = true        -- Show some invisible characters (tabs...
opt.tabstop = 2        -- Number of spaces tabs count for
opt.shiftround = true  -- Round indent
opt.shiftwidth = 2     -- Size of an indent
opt.smartindent = true -- Insert indents automatically
opt.expandtab = true

-- line wrapping
opt.wrap = false -- Disable line wrap

-- search settings
opt.ignorecase = true -- Ignore case
opt.smartcase = true  -- Don't ignore case with capitals

-- cursor line
opt.cursorline = true -- Enable highlighting of the current line

-- appeareance
opt.termguicolors = true -- True color support
opt.background = "dark"

-- backspace
opt.backspace = "indent,eol,start"

opt.autowrite = true
opt.clipboard = "unnamedplus"
-- opt.cmdheight = 0            -- More space for displaying messages
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3         -- Hide * markup for bold and italic
opt.confirm = true           -- Confirm to save changes before exiting modified buffer
opt.formatoptions = "joqlnt" -- tcq
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 0
opt.foldlevelstart = 99
opt.mouse = "a"    -- Enable muse mode
opt.pumblend = 10  -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.scrolloff = 4  -- Lines of contex
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shortmess:append({ W = true, I = true, c = true })
opt.showcmd = true
opt.showmode = false   -- Dont show mode since we have a statusline
opt.sidescrolloff = 4
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.spelllang = { "en" }
opt.splitbelow = true  -- Put new windows below current
opt.splitright = true  -- Put new windows right of current
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200               -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winbar = "%=%m %f"
opt.winminwidth = 10               -- Minimum window width
