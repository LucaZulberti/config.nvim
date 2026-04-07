local funcs = require("lucazulbe.functions")
local rmap = funcs.rmap

require("tv").setup {}

rmap("n", "<leader>pf", ":Tv files<CR>", "[Tv] Files")
rmap("n", "<leader>ps", ":Tv text<CR>", "[Tv] Live Grep")
rmap("n", "<leader>pe", ":Tv env<CR>", "[Tv] Environment")
rmap("n", "<leader>pgf", ":Tv git-files<CR>", "[Tv] Git Files")
rmap("n", "<leader>pgl", ":Tv git-log<CR>", "[Tv] Git Log")
rmap("n", "<leader>pgr", ":Tv git-reflog<CR>", "[Tv] Git Reflog")
rmap("n", "<leader>pgb", ":Tv git-branch<CR>", "[Tv] Git Branch")
rmap("n", "<leader>pgw", ":Tv git-worktrees<CR>", "[Tv] Git Worktrees")
rmap("n", "<leader>pt", ":Tv tmux-sessions<CR>", "[Tv] Tmux Sessions")

-- rmap("n", "<leader>ph", ":Pick help<CR>", "[Mini.Pick] Help")
-- rmap("n", "<leader>pd", ":Pick diagnostic<CR>", "[Mini.Pick] Diagnostic")
-- rmap("n", "<leader>plq", ":Pick list scope='quickfix'<CR>", "[Mini.Pick] Quickfix List")
-- rmap("n", "<leader>pll", ":Pick list scope='location'<CR>", "[Mini.Pick] Location List")
-- rmap("n", "<leader>plj", ":Pick list scope='jump'<CR>", "[Mini.Pick] Jump List")
-- rmap("n", "<leader>plc", ":Pick list scope='change'<CR>", "[Mini.Pick] Change List")
-- rmap("n", "<leader>pm", ":Pick marks<CR>", "[Mini.Pick] Marks")
-- rmap("n", "<leader>pr", ":Pick registers<CR>", "[Mini.Pick] Registers")
-- rmap("n", "<leader>pk", ":Pick keymaps<CR>", "[Mini.Pick] Keymaps")
