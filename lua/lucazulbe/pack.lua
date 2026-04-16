local funcs = require("lucazulbe.functions")
local rmap = funcs.rmap

local gh = function(x) return 'https://github.com/' .. x end

-- Plugin installation
-- -------------------

vim.pack.add({
    -- Dependency for some plugins
    { src = gh("nvim-lua/plenary.nvim") },

    -- Colorschemes
    { src = gh("rose-pine/neovim") },
    { src = gh("catppuccin/nvim") },

    -- Miscellaneous
    { src = gh("Eandrju/cellular-automaton.nvim") },
    { src = gh("tpope/vim-sleuth") },
    { src = gh("tpope/vim-fugitive") },
    { src = gh("mhinz/vim-signify") },
    { src = gh("stevearc/oil.nvim") },
    { src = gh("christoomey/vim-tmux-navigator") },

    -- mini.nvim modules
    { src = gh("echasnovski/mini.ai") },
    { src = gh("echasnovski/mini.operators") },
    { src = gh("echasnovski/mini.surround") },
    { src = gh("echasnovski/mini.snippets") },
    { src = gh("echasnovski/mini.completion") },
    { src = gh("echasnovski/mini.hipatterns") },
    { src = gh("echasnovski/mini.move") },
    { src = gh("echasnovski/mini.pairs") },
    { src = gh("echasnovski/mini.files") },
    { src = gh("echasnovski/mini.extra") },
    { src = gh("echasnovski/mini.icons") },
    { src = gh("echasnovski/mini.trailspace") },

    -- Telescope picker
    { src = gh("nvim-telescope/telescope.nvim") },
    { src = gh("nvim-telescope/telescope-symbols.nvim") },
    { src = gh("nvim-telescope/telescope-live-grep-args.nvim") },
    { src = gh("nvim-telescope/telescope-frecency.nvim") },
    { src = gh("nvim-telescope/telescope-file-browser.nvim") },

    -- Treesitter and UI
    { src = gh("nvim-treesitter/nvim-treesitter"),             version = 'main' },
    { src = gh("j-hui/fidget.nvim") },

    -- LSP and Formatter
    { src = gh("neovim/nvim-lspconfig") },
    { src = gh("mason-org/mason.nvim") },
    { src = gh("mason-org/mason-lspconfig.nvim") },
    { src = gh("stevearc/conform.nvim") },

    -- Dependencies and build tooling
    { src = gh("nvim-lua/plenary.nvim") },
    { src = gh("Civitasv/cmake-tools.nvim") },

    -- Documentation
    { src = gh("danymat/neogen") },

    -- Debugging
    { src = gh("mfussenegger/nvim-dap") },
    { src = gh("theHamsta/nvim-dap-virtual-text") },
    { src = gh("nvim-neotest/nvim-nio") },
    { src = gh("rcarriga/nvim-dap-ui") },

    -- Markup and document preview
    { src = gh("OXY2DEV/markview.nvim") },
    { src = gh("chomosuke/typst-preview.nvim") },

    -- Language-specific tooling
    { src = gh("mrcjkb/rustaceanvim") },
})

-- Plugin configuration
-- --------------------

-- Configure the default colorscheme variant.
require("rose-pine").setup({
    variant = "moon",
})

-- Fuzzy finders and more utilities
require("oil").setup()
-- require("lucazulbe.pack.tv")
require("lucazulbe.pack.telescope")
require("lucazulbe.pack.mini")

require("nvim-treesitter").install { "lua", "vim", "bash", "fish", "c", "cpp" }

require("fidget").setup()

-- Set up Mason and bridge it to lspconfig-managed servers.
require("mason").setup()
require("mason-lspconfig").setup()

require("neogen").setup()

-- Load local formatter and CMake/DAP integration modules.
require("lucazulbe.pack.conform")
require("lucazulbe.pack.cmake-dap")

require("typst-preview").setup()

-- Plugin keymaps
-- --------------

rmap("n", "<leader>R", "<cmd>CellularAutomaton make_it_rain<CR>", "[Meme] Make it rain")

rmap("n", "<leader>e", ":Oil<CR>", "[Oil] Explore filesystem")
