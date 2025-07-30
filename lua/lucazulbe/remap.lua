vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Move text
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join next line" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- Move cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Go down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Go up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Go next, center, and unfold" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Go previous, center, and unfold" })

-- System clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank to system clipboard" })

-- Registers
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable replay last recorded register" })

-- Void register
vim.keymap.set("x", "<leader>p", function()
  -- Get the cursor position at the end of the visual selection.
  -- Returns [bufnum, lnum (line), col (column), offset]
  local end_pos = vim.fn.getpos(".")
  local lnum = end_pos[2]         -- Line number of the cursor
  local col = end_pos[3]          -- Column number (1-based)

  -- Get the full line text at the current line
  local line = vim.fn.getline(lnum)

  -- Check if the cursor is at or beyond the end of the line
  -- (i.e. selection ends at last character or further)
  local is_eol = (col >= #line)

  if is_eol then
    -- Use 'p' to paste after the cursor when selection ends at line end.
    -- Prevents pasting one char too far left.
    vim.cmd('normal! "_dp')
  else
    -- Use 'P' to paste before the cursor when selection is in the middle of the line.
    vim.cmd('normal! "_dP')
  end
end, { desc = "Smart replace without yanking" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete into void register" })
vim.keymap.set({ "n", "v" }, "<leader>c", [["_c]], { desc = "Change into void register" })
vim.keymap.set({ "n", "v" }, "<leader>di", [["_di]], { desc = "Delete into void register inside" })
vim.keymap.set({ "n", "v" }, "<leader>ci", [["_ci]], { desc = "Change into void register inside" })

-- Replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word under cursor" })

-- Project
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open project view" })

-- QuickFix navigation shortcuts
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Go to next quickfix item" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Go to previous quickfix item" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Go to next location list item" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Go to previous location list item" })

-- Work on current file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make the current file executable" })
vim.keymap.set("n", "<leader><leader>", "<cmd>so<CR>", { desc = "Source the current file" });
vim.keymap.set("n", "<leader>r", "<cmd>e!<CR>", { desc = "Reload current file from disk" })

vim.keymap.set('n', 'zr', function()
  vim.fn.setreg('"', vim.fn.expand('%'))
  print('Copied: ' .. vim.fn.expand('%'))
end, { desc = 'Copy relative file path' })
vim.keymap.set('n', 'zf', function()
  vim.fn.setreg('"', vim.fn.expand('%:p'))
  print('Copied: ' .. vim.fn.expand('%:p'))
end, { desc = 'Copy full file path' })
vim.keymap.set('n', 'Zr', function()
  vim.fn.setreg('+', vim.fn.expand('%'))
  print('Copied (clipboard): ' .. vim.fn.expand('%'))
end, { desc = 'Copy relative file path to system clipboard' })
vim.keymap.set('n', 'Zf', function()
  vim.fn.setreg('+', vim.fn.expand('%:p'))
  print('Copied (clipboard): ' .. vim.fn.expand('%:p'))
end, { desc = 'Copy full file path to system clipboard' })

-- Misc
vim.keymap.set("n", "<leader>vvv", "<cmd>e ~/.config/nvim<CR>", { desc = "Edit Neovim config" });
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Escape in insert mode" })
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww ~/.config/tmuxp/tmuxp-sessionizer<CR>",
    { desc = "Open tmuxp sessionizer" })
