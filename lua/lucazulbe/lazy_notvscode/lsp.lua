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
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")

        require("fidget").setup({})
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

        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )
        local on_attach = function(client, bufnr)
            -- Mappings
            local opts = { noremap = true, silent = true, buffer = bufnr }

            -- See `:help vim.lsp.*` for documentation on any of the below functions

            vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts,
                { desc = "Hover info" }))
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts,
                { desc = "Signature info" }))

            vim.keymap.set('n', '<space>lD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts,
                { desc = "Jump to declaration" }))
            vim.keymap.set('n', '<space>ld', vim.lsp.buf.definition, vim.tbl_extend('force', opts,
                { desc = "Jump to definition" }))
            vim.keymap.set('n', '<space>lv', '<cmd>vsplit | lua vim.lsp.buf.definition()<CR>',
                vim.tbl_extend('force', opts,
                    { desc = "Open definition in vertical split" }))
            vim.keymap.set('n', '<space>lh', '<cmd>split | lua vim.lsp.buf.definition()<CR>',
                vim.tbl_extend('force', opts,
                    { desc = "Open definition in horizzontal split" }))
            vim.keymap.set('n', '<space>lt', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>',
                vim.tbl_extend('force', opts,
                    { desc = "Open definition in a new tab" }))

            vim.keymap.set('n', '<space>lrf', vim.lsp.buf.references, vim.tbl_extend('force', opts,
                { desc = "List references of current symbol" }))
            vim.keymap.set('n', '<space>lrn', vim.lsp.buf.rename, vim.tbl_extend('force', opts,
                { desc = "Rename current symbol" }))
            vim.keymap.set('n', '<space>lca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts,
                { desc = "List code actions" }))

            vim.keymap.set('n', '<space>lwa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend('force', opts,
                { desc = "Add working directory or current folder to workspace list" }))
            vim.keymap.set('n', '<space>lwr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend('force', opts,
                { desc = "Remove working directory or current folder to workspace list" }))
            vim.keymap.set('n', '<space>lwl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, vim.tbl_extend('force', opts,
                { desc = "List workspace folders" }))
        end

        -- Configure language servers
        vim.lsp.config('lua_ls', {
            capabilities = capabilities,
            on_attach = on_attach,
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
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { "clangd", "--background-index", "--compile-commands-dir=." },
            root_markers = { 'compile_commands.json' },
        })
        vim.lsp.config('angularls', {
            cmd = { "ngserver", "--stdio", "--tsProbeLocations", ".", "--ngProbeLocations", "." },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                -- Disable formatting, prettier is used
                client.server_capabilities.documentFormattingProvider = false
            end,
            root_markers = { "angular.json", "package.json", "tsconfig.json", ".git" },
        })
        vim.lsp.config('ts_ls', {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                -- Disable formatting, prettier is used
                client.server_capabilities.documentFormattingProvider = false
            end,
        })
        vim.lsp.config('tailwindcss', {
            cmd = { "tailwindcss-language-server", "--stdio" },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                -- Disable formatting, prettier is used
                client.server_capabilities.documentFormattingProvider = false
            end,
        })
        vim.lsp.config('vhdl_ls', {
            capabilities = capabilities,
            on_attach = on_attach
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
