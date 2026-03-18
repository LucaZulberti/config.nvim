require("conform").setup({
    formatters = {
        vsg = {
            command = "vsg",
            stdin = false,
            args = function(_, ctx)
                local cfg = vim.fs.find(
                    { "vsg.yaml", "vsg.yml" },
                    { path = vim.fs.dirname(ctx.filename), upward = true }
                )[1]

                if cfg then
                    return { "-c", cfg, "-f", "$FILENAME", "--fix" }
                end
                return { "-of", "syntastic", "-f", "$FILENAME", "--fix" }
            end,
        },
    },
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
        vhdl = { "vsg" },
    },
    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 2000,
        lsp_format = "fallback",
    },
})
