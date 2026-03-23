local funcs = require("lucazulbe.functions")
local rmap = funcs.rmap


-- Motion training
-- ---------------

-- Disable arrow-style navigation keys to reinforce native Vim motions.
for _, key in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>", "<PageUp>", "<PageDown>", "<Home>", "<End>" }) do
    funcs.disable_keymap_and_notify(key)
end

-- Neovim
-- ------

rmap("n", "<leader>Q", ":quitall<CR>", "[Neovim] Quit")
rmap("n", "<leader>O", ":restart<CR>", "[Neovim] Restart")
rmap("n", "<leader>vvv", "<cmd>e ~/.config/nvim<CR>", "[Neovim] Edit config")

-- File
-- ----

rmap("n", "<leader>o", ":update<CR> :source<CR>", "[File] Source")
rmap("n", "<leader>w", ":write<CR>", "[File] Write")
rmap("n", "<leader>q", ":quit<CR>", "[File] Quit")
rmap("n", "<leader>r", "<cmd>edit!<CR>", "[File] Reload")
rmap("n", "<leader>x", "<cmd>!chmod +x %<CR>", "[File] Make executable")

rmap("n", "<leader>zr", function()
    -- Copy the current buffer path relative to the working directory.
    vim.fn.setreg([["]], vim.fn.expand("%"))
    print("Copied: " .. vim.fn.expand("%"))
end, "[File] Copy relative path")

rmap("n", "<leader>zf", function()
    -- Copy the absolute path of the current buffer.
    vim.fn.setreg([["]], vim.fn.expand("%:p"))
    print("Copied: " .. vim.fn.expand("%:p"))
end, "[File] Copy full path")

rmap("n", "<leader>Zr", function()
    -- Copy the current buffer path relative to the working directory into the
    -- system clipboard register.
    vim.fn.setreg("+", vim.fn.expand("%"))
    print("Copied (clipboard): " .. vim.fn.expand("%"))
end, "[File] Copy relative path to system clipboard")

rmap("n", "<leader>Zf", function()
    -- Copy the absolute path of the current buffer into the system clipboard
    -- register.
    vim.fn.setreg("+", vim.fn.expand("%:p"))
    print("Copied (clipboard): " .. vim.fn.expand("%:p"))
end, "[File] Copy full path to system clipboard")

-- Text
-- ----

rmap("i", "<C-c>", "<Esc>", "[Text] Escape while in insert mode")
rmap("n", "J", "mzJ`z", "[Text] Join next line")
rmap("v", "J", ":m '>+1<CR>gv=gv", "[Text] Move selected lines down")
rmap("v", "K", ":m '<-2<CR>gv=gv", "[Text] Move selected lines up")

-- Search and replace
-- ------------------

rmap("n", "<leader>s", function()
    -- Prepare a replace command from the current search register in the current file.
    funcs.replace_last_search(false)
end, "[Text] Replace last search (current file)")

rmap("n", "<leader>S", function()
    -- Prepare a replace command from the current search register across all files.
    funcs.replace_last_search(true)
end, "[Text] Replace last search (all files)")

rmap("v", "<leader>s", function()
    -- Prepare a replace command from the current visual selection in the current file.
    funcs.replace_selection(false)
end, "[Text] Replace selection (current file)")

rmap("v", "<leader>S", function()
    -- Prepare a replace command from the current visual selection across all files.
    funcs.replace_selection(true)
end, "[Text] Replace selection (all files)")

rmap("n", "<leader><M-s>", function()
    -- Prompt for a Vim regex and prepare a replace command in the current file.
    funcs.replace_prompted_regex(false)
end, "[Text] Replace prompted regex (current file)")

rmap("n", "<leader><M-S>", function()
    -- Prompt for a Vim regex and prepare a replace command across all files.
    funcs.replace_prompted_regex(true)
end, "[Text] Replace prompted regex (all files)")

-- Cursor
-- ------

rmap("n", "<C-d>", "<C-d>zz", "[Cursor] Go down and center")
rmap("n", "<C-u>", "<C-u>zz", "[Cursor] Go up and center")
rmap("n", "n", "nzzzv", "[Cursor] Go next, center, and unfold")
rmap("n", "N", "Nzzzv", "[Cursor] Go previous, center, and unfold")

-- Clipboard
-- ---------

rmap({ "n", "v" }, "<leader>y", [["+y]], "[Clipboard] Copy")
rmap({ "n", "v" }, "<leader>Y", [["+Y]], "[Clipboard] Copy line")

-- Void register
-- -------------

rmap("x", "<leader>p", function()
    -- Read the cursor position at the end of the visual selection.
    -- getpos() returns: [bufnum, lnum, col, off]
    local end_pos = vim.fn.getpos(".")
    local lnum = end_pos[2]
    local col = end_pos[3]

    -- Inspect the current line so we can determine whether the selection ends at
    -- the last visible character.
    local line = vim.fn.getline(lnum)
    local is_eol = (col >= #line)

    if is_eol then
        -- When the selection ends at line end, paste after deletion so the
        -- replacement lands in the expected position.
        vim.cmd([[normal! "_dp]])
    else
        -- When the selection ends inside the line, paste before the cursor so the
        -- replacement starts exactly at the deleted region.
        vim.cmd([[normal! "_dP]])
    end
end, "[Void] Replace without yanking")

rmap({ "n", "v" }, "<leader>d", [["_d]], "[Void] Delete without yank")
rmap({ "n", "v" }, "<leader>c", [["_c]], "[Void] Change without yank")
rmap({ "n", "v" }, "<leader>di", [["_di]], "[Void] Delete inside without yank")
rmap({ "n", "v" }, "<leader>ci", [["_ci]], "[Void] Change inside without yank")

-- Windows
-- -------

rmap("n", "<C-h>", "<C-w>h", "[Windows] Move to left")
rmap("n", "<C-j>", "<C-w>j", "[Windows] Move to lower")
rmap("n", "<C-k>", "<C-w>k", "[Windows] Move to upper")
rmap("n", "<C-l>", "<C-w>l", "[Windows] Move to right")

rmap("n", "<C-Left>", function()
    -- Move the active vertical split border one column to the left.
    funcs.move_vsep(-1)
end, "[Windows] Move split left")

rmap("n", "<C-Right>", function()
    -- Move the active vertical split border one column to the right.
    funcs.move_vsep(1)
end, "[Windows] Move split right")

rmap("n", "<C-Up>", function()
    -- Move the active horizontal split border one row upward.
    funcs.move_hsep(-1)
end, "[Windows] Move split up")

rmap("n", "<C-Down>", function()
    -- Move the active horizontal split border one row downward.
    funcs.move_hsep(1)
end, "[Windows] Move split down")

rmap("n", "<S-Left>", function()
    -- Shrink the current window width, honoring a numeric count when provided.
    funcs.resize_current_width(-vim.v.count1)
end, "[Windows] Shrink current width")

rmap("n", "<S-Right>", function()
    -- Grow the current window width, honoring a numeric count when provided.
    funcs.resize_current_width(vim.v.count1)
end, "[Windows] Grow current width")

rmap("n", "<S-Up>", function()
    -- Grow the current window height, honoring a numeric count when provided.
    funcs.resize_current_height(vim.v.count1)
end, "[Windows] Grow current height")

rmap("n", "<S-Down>", function()
    -- Shrink the current window height, honoring a numeric count when provided.
    funcs.resize_current_height(-vim.v.count1)
end, "[Windows] Shrink current height")
