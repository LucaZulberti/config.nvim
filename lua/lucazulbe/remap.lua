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
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Replace into void register" })
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

-- Misc
vim.keymap.set("n", "<leader>vvv", "<cmd>e ~/.config/nvim<CR>", { desc = "Edit Neovim config" });
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Escape in insert mode" })
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww ~/.config/tmuxp/tmuxp-sessionizer<CR>",
    { desc = "Open tmuxp sessionizer" })
