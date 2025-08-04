return {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",

        -- Snippet engine for Neovim
        "L3MON4D3/LuaSnip",

        -- Completions
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "saadparwaiz1/cmp_luasnip",

        -- Extensible UI for Neovim notifications and LSP progress messages
        "j-hui/fidget.nvim",
    },

    config = function()
        -- My modules
        local lz_lsp = require("lucazulbe.lsp")

        -- Completions
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")

        -- Overlay in bottom right corner for LSP messages
        require("fidget").setup({})

        -- LSP Plugins managare
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        })
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "clangd",
                "angularls",
                "ts_ls",
                "tailwindcss",
                "vhdl_ls",
            }
        })

        -- Configure language servers
        vim.lsp.config('*', {
            capabilities = vim.tbl_deep_extend("force", lz_lsp.config.capabilities, cmp_lsp.default_capabilities()),
            on_attach = lz_lsp.on_attach,
        })
        vim.lsp.config('lua_ls', {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }, -- Declare 'vim' as a global
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                },
            },
        })
        vim.lsp.config('clangd', {
            cmd = { "clangd", "--background-index", "--compile-commands-dir=." },
            root_markers = { 'compile_commands.json' },
        })
        vim.lsp.config('angularls', {
            cmd = { "ngserver", "--stdio", "--tsProbeLocations", ".", "--ngProbeLocations", "." },
            on_attach = function(client, bufnr)
                lz_lsp.config.on_attach(client, bufnr)
                -- Disable formatting, prettier is used
                client.server_capabilities.documentFormattingProvider = false
            end,
            root_markers = { "angular.json", "package.json", "tsconfig.json", ".git" },
        })
        vim.lsp.config('ts_ls', {
            on_attach = function(client, bufnr)
                lz_lsp.config.on_attach(client, bufnr)
                -- Disable formatting, prettier is used
                client.server_capabilities.documentFormattingProvider = false
            end,
        })
        vim.lsp.config('tailwindcss', {
            cmd = { "tailwindcss-language-server", "--stdio" },
            on_attach = function(client, bufnr)
                lz_lsp.config.on_attach(client, bufnr)
                -- Disable formatting, prettier is used
                client.server_capabilities.documentFormattingProvider = false
            end,
        })
        vim.lsp.config('vhdl_ls', {
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = true,
                header = "",
                prefix = "",
            },
        })

        vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, { desc = "Show diagnostics" })

        vim.keymap.set("n", "<leader>lR", function()
            local bufnr = vim.api.nvim_get_current_buf()
            local clients = vim.lsp.get_clients({ bufnr = bufnr })

            for _, client in ipairs(clients) do
                vim.lsp.stop_client(client.id)
            end

            vim.defer_fn(function()
                vim.cmd("edit") -- re-edit buffer to retrigger LSP attachment
            end, 100)
        end, { desc = "Restart LSP for current buffer" })
    end
}
