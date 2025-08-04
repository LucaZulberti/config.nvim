return {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
        local conform = require("conform")

        conform.setup({
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
            format_on_save = true, -- optional
        })

        -- Set keymap to format
        vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
            conform.format({
                async = true,
                lsp_fallback = true,
            })
        end, { desc = "Format current buffer or selection" })
    end
}
