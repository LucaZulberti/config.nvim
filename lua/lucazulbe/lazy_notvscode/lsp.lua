return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
            }
        })

        vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

        local on_attach = function(client, bufnr)
            -- Buffer-local keybindings for LSP
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition,
                vim.tbl_extend("force", opts, { desc = "Go to symbol definition" }))
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
                vim.tbl_extend("force", opts, { desc = "Go to symbol implementation" }))
            vim.keymap.set("n", "gr", vim.lsp.buf.references,
                vim.tbl_extend("force", opts, { desc = "Show symbol references" }))
            vim.keymap.set("n", "K", vim.lsp.buf.hover,
                vim.tbl_extend("force", opts, { desc = "Show hover symbol information" }))
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
                vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
                vim.tbl_extend("force", opts, { desc = "Code actions..." }))
            vim.keymap.set("n", "<leader>f", function()
                vim.lsp.buf.format({ async = true })
            end, vim.tbl_extend("force", opts, { desc = "Format current buffer" }))

            -- Additional LSP behavior
            if client.server_capabilities.documentHighlightProvider then
                -- Use underline for document highlights
                vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
                vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true })
                vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true })

                vim.api.nvim_create_autocmd("CursorHold", {
                    buffer = bufnr,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd("CursorMoved", {
                    buffer = bufnr,
                    callback = vim.lsp.buf.clear_references,
                })
            end
        end

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        on_attach = on_attach, -- Attach the local on_attach function
                    }
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        on_attach = on_attach, -- Attach the local on_attach function
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
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
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
