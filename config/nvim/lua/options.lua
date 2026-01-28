-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

local opt = vim.opt
-- local o = vim.o
local g = vim.g

-------------------------------------- options ------------------------------------------
opt.guicursor = ""
opt.spell = false
opt.signcolumn = "yes"
opt.wrap = false
opt.showmode = false -- conflicts with native statusline mode indicator, causing flickering
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.colorcolumn = "100"
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = true
opt.conceallevel = 0

-- Splits
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

-- Editing
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.undofile = true
opt.timeoutlen = 0 -- better-escape.nvim ?

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- Performance
-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- Disable providers
-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Line Numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4
opt.ruler = false

opt.laststatus = 3

opt.cursorline = true
opt.cursorlineopt = "number"

-- Indenting
opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true

-- Numbers
opt.number = true
opt.numberwidth = 4 -- initially 2
opt.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

opt.signcolumn = "yes"

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
