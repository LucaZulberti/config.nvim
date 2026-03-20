-- Shortcut
local map = vim.keymap.set

-- Helper for less boilerplate
local function rmap(mode, lhs, fn, desc)
    map(mode, lhs, fn, { desc = desc })
end

-- Install plugins
vim.pack.add({
    -- RosePine Theme
    { src = "https://github.com/rose-pine/neovim" },

    -- Catppuccin Theme
    { src = "https://github.com/catppuccin/nvim" },

    -- Useless automation for sad mood
    { src = "https://github.com/Eandrju/cellular-automaton.nvim" },

    -- Heuristically set buffer options
    { src = "https://github.com/tpope/vim-sleuth" },

    -- A Git wrapper so awesome, it should be illegal
    { src = "https://github.com/tpope/vim-fugitive" },

    -- Add signs column
    { src = "https://github.com/mhinz/vim-signify" },

    -- Documentation generation
    { src = "https://github.com/danymat/neogen" },

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

    -- Plenary
    { src = "https://github.com/nvim-lua/plenary.nvim" },

    -- CMake Tools
    { src = "https://github.com/Civitasv/cmake-tools.nvim" },

    -- Debug Adapter Protocol client implementation for Neovim
    { src = "https://github.com/mfussenegger/nvim-dap" },

    -- Inline virtual text for variable values
    { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },

    -- A library for asynchronous IO in Neovim
    -- Needed by:
    --  - nvim-dap-ui
    { src = "https://github.com/nvim-neotest/nvim-nio" },

    -- A UI for nvim-dap
    { src = "https://github.com/rcarriga/nvim-dap-ui" },

    -- A hackable markdown, Typst, latex, html(inline) & YAML previewer
    { src = "https://github.com/OXY2DEV/markview.nvim" },

    -- Low latency typst preview
    { src = "https://github.com/chomosuke/typst-preview.nvim" },

    -- Supercharge your Rust experience in Neovim
    { src = "https://github.com/mrcjkb/rustaceanvim" },
})

-- Configure plugins
---

require("rose-pine").setup({
    variant = "moon"
})

require("oil").setup()

require("neogen").setup()

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
vim.api.nvim_set_hl(0, "MiniHipatternsTest", { fg = "#232136", bg = "#ff6842", bold = true })

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
        test  = { pattern = '%f[%w]()TEST()%f[%W]', group = 'MiniHipatternsTest' },


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

require("lucazulbe.pack.conform")

require("lucazulbe.pack.cmake-dap")

require("typst-preview").setup()

-- Remap plugin commands
---

rmap("n", "<leader>R", "<cmd>CellularAutomaton make_it_rain<CR>", "[Meme] Make it rain")

rmap('n', '<leader>e', ":Oil<CR>", "[Oil] Explore filesystem")

rmap('n', '<leader>pf', ":Pick files<CR>", "[Mini.Pick] Files")
rmap('n', '<leader>ph', ":Pick help<CR>", "[Mini.Pick] Help")
rmap('n', '<leader>pd', ":Pick diagnostic<CR>", "[Mini.Pick] Diagnostic")
rmap('n', '<leader>pe', ":Pick explorer<CR>", "[Mini.Pick] Explorer")
rmap('n', '<leader>ps', ":Pick grep_live<CR>", "[Mini.Pick] Grep Live")
rmap('n', '<leader>pa', ":Pick grep<CR>", "[Mini.Pick] Grep")
rmap('n', '<leader>pgf', ":Pick git_files<CR>", "[Mini.Pick] Git Files")
rmap('n', '<leader>pgl', ":Pick git_commits<CR>", "[Mini.Pick] Git Log")
rmap('n', '<leader>pgh', ":Pick git_hunks<CR>", "[Mini.Pick] Git Hunks")
rmap('n', '<leader>plq', ":Pick list scope='quickfix'<CR>", "[Mini.Pick] Quickfix List")
rmap('n', '<leader>pll', ":Pick list scope='location'<CR>", "[Mini.Pick] Location List")
rmap('n', '<leader>plj', ":Pick list scope='jump'<CR>", "[Mini.Pick] Jump List")
rmap('n', '<leader>plc', ":Pick list scope='change'<CR>", "[Mini.Pick] Change List")
rmap('n', '<leader>pm', ":Pick marks<CR>", "[Mini.Pick] Marks")
rmap('n', '<leader>pr', ":Pick registers<CR>", "[Mini.Pick] Registers")
rmap('n', '<leader>pk', ":Pick keymaps<CR>", "[Mini.Pick] Keymaps")

rmap('n', '<leader>f', function()
    require("mini.files").open()
end, "[Mini.Files] Open")

rmap({ 'n', 'v' }, '<leader>lf', function()
    require("conform").format({
        async = true,
        lsp_format = "fallback",
    })
end, "[Conform] Format current buffer or selection")
