local funcs = require("lucazulbe.functions")

-- Shortcut
local map = vim.keymap.set

-- Force to learn Vim-Motions
for _, key in ipairs { '<Up>', '<Down>', '<Left>', '<Right>', '<PageUp>', '<PageDown>', '<Home>', '<End>' } do
    funcs.disable_keymap_and_notify(key)
end

-- General
map("n", "<leader>O", function() vim.cmd("restart") end, { desc = "[Neovim] Restart" })
map("n", "<leader>vvv", "<cmd>e ~/.config/nvim<CR>", { desc = "[Neovim] Edit config" });

-- Working with current file
map("n", "<leader>o", ":update<CR> :source<CR>", { desc = "[File] Source" })
map("n", "<leader>w", ":write<CR>", { desc = "[File] Write" })
map("n", "<leader>q", ":quit<CR>", { desc = "[File] Quit" })
map("n", "<leader>r", "<cmd>edit!<CR>", { desc = "[File] Reload" })
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "[File] Make executable" })
map("n", "<leader>zr", function()
    vim.fn.setreg([["]], vim.fn.expand("%"))
    print('Copied: ' .. vim.fn.expand("%"))
end, { desc = '[File] Copy relative path' })
map("n", "<leader>zf", function()
    vim.fn.setreg([["]], vim.fn.expand("%:p"))
    print('Copied: ' .. vim.fn.expand("%:p"))
end, { desc = '[File] Copy full path' })
map("n", "<leader>Zr", function()
    vim.fn.setreg("+", vim.fn.expand("%"))
    print('Copied (clipboard): ' .. vim.fn.expand("%"))
end, { desc = '[File] Copy relative path to system clipboard' })
map("n", "<leader>Zf", function()
    vim.fn.setreg("+", vim.fn.expand("%:p"))
    print('Copied (clipboard): ' .. vim.fn.expand("%:p"))
end, { desc = '[File] Copy full path to system clipboard' })

-- Text manipulation
map("i", "<C-c>", "<Esc>", { desc = "[Text] Escape while in insert mode" })
map("n", "J", "mzJ`z", { desc = "[Text] Join next line" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "[Text] Move selected lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "[Text] Move selected lines up" })
map("n", "<leader>s", function()
    funcs.replace_word_under_cursor(false)
end, { desc = "[Text] Replace word under cursor (location list, current file)" })
map("n", "<leader>S", function()
    funcs.replace_word_under_cursor(true)
end, { desc = "[Text] Replace word under cursor (quickfix, all files)" })

-- Cursor
map("n", "<C-d>", "<C-d>zz", { desc = "[Cursor] Go down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "[Cursor] Go up and center" })
map("n", "n", "nzzzv", { desc = "[Cursor] Go next, center, and unfold" })
map("n", "N", "Nzzzv", { desc = "[Cursor] Go previous, center, and unfold" })

-- System clipboard
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "[Clipboard] Copy" })
map({ "n", "v" }, "<leader>Y", [["+Y]], { desc = "[Clipboard] Copy line" })

-- Void register
map("x", "<leader>p", function()
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
end, { desc = "[Void] Replace without yanking" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "[Void] Delete without yank" })
map({ "n", "v" }, "<leader>c", [["_c]], { desc = "[Void] Change without yank" })
map({ "n", "v" }, "<leader>di", [["_di]], { desc = "[Void] Delete inside without yank" })
map({ "n", "v" }, "<leader>ci", [["_ci]], { desc = "[Void] Change inside without yank" })

-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "[Windows] Move to left" })
map("n", "<C-j>", "<C-w>j", { desc = "[Windows] Move to lower" })
map("n", "<C-k>", "<C-w>k", { desc = "[Windows] Move to upper" })
map("n", "<C-l>", "<C-w>l", { desc = "[Windows] Move to right" })
