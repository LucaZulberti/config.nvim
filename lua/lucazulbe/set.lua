-- Input
-- -----

-- Disable mouse support to reinforce keyboard-only navigation.
vim.o.mouse = ""

-- Leader
-- ------

-- Use <Space> as the global leader key.
vim.g.mapleader = " "

-- Appearance
-- ----------

-- Disable persistent search highlighting after a search completes.
vim.o.hlsearch = false

-- Show matches incrementally while typing a search pattern.
vim.o.incsearch = true

-- Show absolute and relative line numbers together.
vim.o.number = true
vim.o.relativenumber = true

-- Keep the sign column visible to avoid text shifting.
vim.o.signcolumn = "yes"

-- Enable true color support in the terminal UI.
vim.o.termguicolors = true

-- Use rounded borders for floating windows when supported.
vim.o.winborder = "rounded"

-- Keep long lines on a single screen row.
vim.o.wrap = false

-- Mark the preferred maximum line width.
vim.o.colorcolumn = "120"

-- Indentation
-- -----------

-- Use four spaces as the default indentation width.
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- Insert spaces instead of literal tab characters.
vim.o.expandtab = true

-- Enable basic automatic indentation for new lines.
vim.o.smartindent = true

-- Formatting
-- ---------

-- Format options:
--  c: auto-wrap comments
--  r: continue comment on <Enter>
--  q: allow gq on comments
vim.o.formatoptions = "crq"

-- Persistence
-- -----------

-- Disable swap and backup files and rely on undo history instead.
vim.o.swapfile = false
vim.o.backup = false

-- Store persistent undo history on disk.
vim.o.undodir = vim.fn.stdpath("state") .. "/undo"
vim.o.undofile = true

-- Responsiveness
-- --------------

-- Reduce update latency for diagnostics, CursorHold events, and similar UI refreshes.
vim.o.updatetime = 250

-- Advanced settings
-- -----------------

require("lucazulbe.set.filetype")
