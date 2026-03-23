local funcs = require("lucazulbe.functions")
local rmap = funcs.rmap

-- Plugin installation
-- -------------------

vim.pack.add({
    -- Colorschemes
    { src = "https://github.com/rose-pine/neovim" },
    { src = "https://github.com/catppuccin/nvim" },

    -- Miscellaneous
    { src = "https://github.com/Eandrju/cellular-automaton.nvim" },
    { src = "https://github.com/tpope/vim-sleuth" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/mhinz/vim-signify" },
    { src = "https://github.com/danymat/neogen" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/christoomey/vim-tmux-navigator" },

    -- mini.nvim modules
    { src = "https://github.com/echasnovski/mini.ai" },
    { src = "https://github.com/echasnovski/mini.operators" },
    { src = "https://github.com/echasnovski/mini.surround" },
    { src = "https://github.com/echasnovski/mini.snippets" },
    { src = "https://github.com/echasnovski/mini.completion" },
    { src = "https://github.com/echasnovski/mini.hipatterns" },
    { src = "https://github.com/echasnovski/mini.move" },
    { src = "https://github.com/echasnovski/mini.pairs" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/echasnovski/mini.files" },
    { src = "https://github.com/echasnovski/mini.extra" },
    { src = "https://github.com/echasnovski/mini.icons" },
    { src = "https://github.com/echasnovski/mini.trailspace" },

    -- Treesitter and UI
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/j-hui/fidget.nvim" },

    -- LSP and tooling
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/stevearc/conform.nvim" },

    -- Dependencies and build tooling
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/Civitasv/cmake-tools.nvim" },

    -- Debugging
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
    { src = "https://github.com/rcarriga/nvim-dap-ui" },

    -- Markup and document preview
    { src = "https://github.com/OXY2DEV/markview.nvim" },
    { src = "https://github.com/chomosuke/typst-preview.nvim" },

    -- Language-specific tooling
    { src = "https://github.com/mrcjkb/rustaceanvim" },
})

-- Plugin configuration
-- --------------------

-- Configure the default colorscheme variant.
require("rose-pine").setup({
    variant = "moon",
})

require("oil").setup()
require("neogen").setup()

-- Enable syntax-aware highlighting and install a small baseline parser set.
require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "vim", "bash", "fish", "c", "cpp" },
    auto_install = true,
    highlight = { enable = true },
})

require("fidget").setup()

-- Set up Mason and bridge it to lspconfig-managed servers.
require("mason").setup()
require("mason-lspconfig").setup()

-- Load local formatter and CMake/DAP integration modules.
require("lucazulbe.pack.conform")
require("lucazulbe.pack.cmake-dap")
require("lucazulbe.pack.mini")

require("typst-preview").setup()

-- Plugin keymaps
-- --------------

rmap("n", "<leader>R", "<cmd>CellularAutomaton make_it_rain<CR>", "[Meme] Make it rain")

rmap("n", "<leader>e", ":Oil<CR>", "[Oil] Explore filesystem")
