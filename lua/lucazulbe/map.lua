local funcs = require("lucazulbe.functions")

-- Shortcut
local map = vim.keymap.set

-- Helper for less boilerplate
local function rmap(mode, lhs, fn, desc)
    map(mode, lhs, fn, { desc = desc })
end

-- Force to learn Vim-Motions
for _, key in ipairs { '<Up>', '<Down>', '<Left>', '<Right>', '<PageUp>', '<PageDown>', '<Home>', '<End>' } do
    funcs.disable_keymap_and_notify(key)
end

-- General
rmap("n", "<leader>Q", ":quitall<CR>", "[Neovim] Quit")
rmap("n", "<leader>O", ":restart<CR>", "[Neovim] Restart")
rmap("n", "<leader>vvv", "<cmd>e ~/.config/nvim<CR>", "[Neovim] Edit config");

-- Working with current file
rmap("n", "<leader>o", ":update<CR> :source<CR>", "[File] Source")
rmap("n", "<leader>w", ":write<CR>", "[File] Write")
rmap("n", "<leader>q", ":quit<CR>", "[File] Quit")
rmap("n", "<leader>r", "<cmd>edit!<CR>", "[File] Reload")
rmap("n", "<leader>x", "<cmd>!chmod +x %<CR>", "[File] Make executable")
rmap("n", "<leader>zr", function()
    vim.fn.setreg([["]], vim.fn.expand("%"))
    print('Copied: ' .. vim.fn.expand("%"))
end, '[File] Copy relative path')
rmap("n", "<leader>zf", function()
    vim.fn.setreg([["]], vim.fn.expand("%:p"))
    print('Copied: ' .. vim.fn.expand("%:p"))
end, '[File] Copy full path')
rmap("n", "<leader>Zr", function()
    vim.fn.setreg("+", vim.fn.expand("%"))
    print('Copied (clipboard): ' .. vim.fn.expand("%"))
end, '[File] Copy relative path to system clipboard')
rmap("n", "<leader>Zf", function()
    vim.fn.setreg("+", vim.fn.expand("%:p"))
    print('Copied (clipboard): ' .. vim.fn.expand("%:p"))
end, '[File] Copy full path to system clipboard')

-- Text manipulation
rmap("i", "<C-c>", "<Esc>", "[Text] Escape while in insert mode")
rmap("n", "J", "mzJ`z", "[Text] Join next line")
rmap("v", "J", ":m '>+1<CR>gv=gv", "[Text] Move selected lines down")
rmap("v", "K", ":m '<-2<CR>gv=gv", "[Text] Move selected lines up")

-- Custom functions
rmap("n", "<leader>s", function() funcs.replace_last_search(false) end, "[Text] Replace last search (current file)")
rmap("n", "<leader>S", function() funcs.replace_last_search(true) end, "[Text] Replace last search (all files)")
rmap("v", "<leader>s", function() funcs.replace_selection(false) end, "[Text] Replace selection (current file)")
rmap("v", "<leader>S", function() funcs.replace_selection(true) end, "[Text] Replace selection (all files)")
rmap("n", "<leader><M-s>", function() funcs.replace_prompted_regex(false) end,
    "[Text] Replace prompted regex (current file)")
rmap("n", "<leader><M-S>", function() funcs.replace_prompted_regex(true) end, "[Text] Replace prompted regex (all files)")

-- Cursor
rmap("n", "<C-d>", "<C-d>zz", "[Cursor] Go down and center")
rmap("n", "<C-u>", "<C-u>zz", "[Cursor] Go up and center")
rmap("n", "n", "nzzzv", "[Cursor] Go next, center, and unfold")
rmap("n", "N", "Nzzzv", "[Cursor] Go previous, center, and unfold")

-- System clipboard
rmap({ "n", "v" }, "<leader>y", [["+y]], "[Clipboard] Copy")
rmap({ "n", "v" }, "<leader>Y", [["+Y]], "[Clipboard] Copy line")

-- Void register
rmap("x", "<leader>p", function()
    -- Get the cursor position at the end of the visual selection.
    -- Returns [bufnum, lnum (line), col (column), offset]
    local end_pos = vim.fn.getpos(".")
    local lnum = end_pos[2] -- Line number of the cursor
    local col = end_pos[3]  -- Column number (1-based)

    -- Get the full line text at the current line
    local line = vim.fn.getline(lnum)

    -- Check if the cursor is at or beyond the end of the line
    -- (i.e. selection ends at last character or further)
    local is_eol = (col >= #line)

    if is_eol then
        -- Use "p" to paste after the cursor when selection ends at line end.
        -- Prevents pasting one char too far left.
        vim.cmd([[normal! "_dp]])
    else
        -- Use "P" to paste before the cursor when selection is in the middle of the line.
        vim.cmd([[normal! "_dP]])
    end
end, "[Void] Replace without yanking")
rmap({ "n", "v" }, "<leader>d", [["_d]], "[Void] Delete without yank")
rmap({ "n", "v" }, "<leader>c", [["_c]], "[Void] Change without yank")
rmap({ "n", "v" }, "<leader>di", [["_di]], "[Void] Delete inside without yank")
rmap({ "n", "v" }, "<leader>ci", [["_ci]], "[Void] Change inside without yank")

-- Windows
rmap("n", "<C-h>", "<C-w>h", "[Windows] Move to left")
rmap("n", "<C-j>", "<C-w>j", "[Windows] Move to lower")
rmap("n", "<C-k>", "<C-w>k", "[Windows] Move to upper")
rmap("n", "<C-l>", "<C-w>l", "[Windows] Move to right")

-- Ctrl+Arrows: move border by direction
rmap("n", "<C-Left>", function()
    funcs.move_vsep(-1)
end, "Move split left")

rmap("n", "<C-Right>", function()
    funcs.move_vsep(1)
end, "Move split right")

rmap("n", "<C-Up>", function()
    funcs.move_hsep(-1)
end, "Move split up")

rmap("n", "<C-Down>", function()
    funcs.move_hsep(1)
end, "Move split down")

-- Shift+Arrows: resize current window
rmap("n", "<S-Left>", function()
    funcs.resize_current_width(-vim.v.count1)
end, "Shrink current window width")

rmap("n", "<S-Right>", function()
    funcs.resize_current_width(vim.v.count1)
end, "Grow current window width")

rmap("n", "<S-Up>", function()
    funcs.resize_current_height(vim.v.count1)
end, "Grow current window height")

rmap("n", "<S-Down>", function()
    funcs.resize_current_height(-vim.v.count1)
end, "Shrink current window height")
