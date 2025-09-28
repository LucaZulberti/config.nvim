-- Force to practice Vim-Motions disabling mouse
vim.o.mouse = ""

-- Global variables
vim.g.mapleader = " "

-- Appearance
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.winborder = "rounded"
vim.o.wrap = false
vim.o.colorcolumn = "120"

-- Indentation defaults
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

-- Metadata files
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true

-- Speed up responsiveness of neovim
vim.o.updatetime = 250 -- 250 ms
