-- Shortcut
local map = vim.keymap.set

-- Install plugins
vim.pack.add({
    -- Theme
    { src = "https://github.com/rose-pine/neovim" },

    -- Useless automation for sad mood
    { src = "https://github.com/Eandrju/cellular-automaton.nvim" },

    -- Heuristically set buffer options
    { src = "https://github.com/tpope/vim-sleuth" },

    -- A Git wrapper so awesome, it should be illegal
    { src = "https://github.com/tpope/vim-fugitive" },

    -- Add Git to signs column
    { src = "https://github.com/lewis6991/gitsigns.nvim" },

    -- File explore and filesystem editor
    { src = "https://github.com/stevearc/oil.nvim" },

    -- Vim-Tmux Navogator
    { src = "https://github.com/christoomey/vim-tmux-navigator" },

    -- Extend and create a/i textobjects
    -- TODO: study
    { src = "https://github.com/echasnovski/mini.ai" },

    -- Text edit operators
    -- TODO: study
    { src = "https://github.com/echasnovski/mini.operators" },

    -- Fast and feature-rich surround actions
    -- TODO: study
    { src = "https://github.com/echasnovski/mini.surround" },

    -- Autocompletion and signature help plugin
    { src = "https://github.com/echasnovski/mini.snippets" },

    -- Autocompletion and signature help plugin
    { src = "https://github.com/echasnovski/mini.completion" },

    -- Highlight patterns in text
    { src = "https://github.com/echasnovski/mini.hipatterns" },

    -- Move any selection in any direction
    { src = "https://github.com/echasnovski/mini.move" },

    -- Autopairs
    { src = "https://github.com/echasnovski/mini.pairs" },

    -- Pick anything
    { src = "https://github.com/echasnovski/mini.pick" },

    -- Navigate and manipulate file system
    { src = "https://github.com/echasnovski/mini.files" },

    -- Extra 'mini.nvim' functionality
    { src = "https://github.com/echasnovski/mini.extra" },

    -- Icon provider
    { src = "https://github.com/echasnovski/mini.icons" },

    -- Work with trailing whitespace
    { src = "https://github.com/echasnovski/mini.trailspace" },

    -- Tree-Sitter
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },

    -- Extensible UI for Neovim notifications
    { src = "https://github.com/j-hui/fidget.nvim" },

    -- LSP Configururations
    { src = "https://github.com/neovim/nvim-lspconfig" },

    -- Package manager for LSP, DAP, linters, formatters
    { src = "https://github.com/mason-org/mason.nvim" },

    -- Makes it easier to use lspconfig with mason.nvim
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },

    -- Lightweight yet powerful formatter
    { src = "https://github.com/stevearc/conform.nvim" },

    -- A hackable markdown, Typst, latex, html(inline) & YAML previewer
    { src = "https://github.com/OXY2DEV/markview.nvim" },

    -- Low latency typst preview
    { src = "https://github.com/chomosuke/typst-preview.nvim" },
})

-- Configure plugins
---

require("rose-pine").setup({
    variant = "moon"
})

require("oil").setup()

require("mini.ai").setup()
require("mini.operators").setup()
require("mini.surround").setup()
require("mini.snippets").setup()
require("mini.completion").setup()
require("mini.pairs").setup()
require("mini.move").setup()

-- New highlight groups
vim.api.nvim_set_hl(0, "MiniHipatternsAlert", { fg = "#232136", bg = "#ff5555", bold = true })
vim.api.nvim_set_hl(0, "MiniHipatternsInfo", { fg = "#232136", bg = "#5fd7ff", bold = true })
vim.api.nvim_set_hl(0, "MiniHipatternsDebug", { fg = "#232136", bg = "#afff87", bold = true })
vim.api.nvim_set_hl(0, "MiniHipatternsPerf", { fg = "#232136", bg = "#ff9e64", bold = true })

require("mini.hipatterns").setup({
    highlighters = {
        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
        hack  = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
        todo  = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
        note  = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
        alert = { pattern = '%f[%w]()ALERT()%f[%W]', group = 'MiniHipatternsAlert' },
        info  = { pattern = '%f[%w]()INFO()%f[%W]', group = 'MiniHipatternsInfo' },
        debug = { pattern = '%f[%w]()DEBUG()%f[%W]', group = 'MiniHipatternsDebug' },
        perf  = { pattern = '%f[%w]()PERF()%f[%W]', group = 'MiniHipatternsPerf' },


        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
    },
})

require("mini.pick").setup()
require("mini.files").setup()
require("mini.extra").setup()
require("mini.icons").setup()
require("mini.trailspace").setup()

require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "vim", "bash", "fish", "c", "cpp" },
    auto_install = true,
    highlight = { enable = true },
}

require("fidget").setup()

require("mason").setup()
require("mason-lspconfig").setup()

require("conform").setup({
    formatters_by_ft = {
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        html = { "prettier" },
        htmlangular = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
    },
    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 2000,
        lsp_format = "fallback",
    },
})

require("typst-preview").setup()

-- Remap plugin commands
---

map("n", "<leader>rain", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "[Meme] Make it rain" })

map('n', '<leader>e', ":Oil<CR>", { desc = "[Oil] Explore filesystem" })

map('n', '<leader>pf', ":Pick files<CR>", { desc = "[Mini.Pick] Files" })
map('n', '<leader>ph', ":Pick help<CR>", { desc = "[Mini.Pick] Help" })
map('n', '<leader>pd', ":Pick diagnostic<CR>", { desc = "[Mini.Pick] Diagnostic" })
map('n', '<leader>pe', ":Pick explorer<CR>", { desc = "[Mini.Pick] Explorer" })
map('n', '<leader>pgf', ":Pick git_files<CR>", { desc = "[Mini.Pick] Git Files" })
map('n', '<leader>pgl', ":Pick git_commits<CR>", { desc = "[Mini.Pick] Git Log" })
map('n', '<leader>pgh', ":Pick git_hunks<CR>", { desc = "[Mini.Pick] Git Hunks" })
map('n', '<leader>plq', ":Pick list scope='quickfix'<CR>", { desc = "[Mini.Pick] Quickfix List" })
map('n', '<leader>pll', ":Pick list scope='location'<CR>", { desc = "[Mini.Pick] Location List" })
map('n', '<leader>plj', ":Pick list scope='jump'<CR>", { desc = "[Mini.Pick] Jump List" })
map('n', '<leader>plc', ":Pick list scope='change'<CR>", { desc = "[Mini.Pick] Change List" })
map('n', '<leader>pm', ":Pick marks<CR>", { desc = "[Mini.Pick] Marks" })
map('n', '<leader>pr', ":Pick registers<CR>", { desc = "[Mini.Pick] Registers" })
map('n', '<leader>pk', ":Pick keymaps<CR>", { desc = "[Mini.Pick] Keymaps" })

map('n', '<leader>f', function()
    require("mini.files").open()
end, { desc = "[Mini.Files] Open" })

map({ 'n', 'v' }, '<leader>lf', function()
    require("conform").format({
        async = true,
        lsp_format = "fallback",
    })
end, { desc = "[Conform] Format current buffer or selection" })
