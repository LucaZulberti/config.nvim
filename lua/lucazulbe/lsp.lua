-- Shortcut
local map = vim.keymap.set

-- Enable LSPs
vim.lsp.enable({ "lua_ls", "fish", "tinymist" })

-- Add LSP commands
---

-- Format with conform in pack.lua
-- map('n', '<leader>lf', vim.lsp.buf.format, { desc = "[LSP] Format current buffer" })

map("n", '<leader>lr', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id)
    end

    vim.defer_fn(function()
        vim.cmd("edit") -- re-edit buffer to retrigger LSP attachment
    end, 100)
end, { desc = "[LSP] Restart for current buffer" })

-- Configure each LSP
---

vim.lsp.config("tinymist", {
    settings = {
        formatterMode = "typstyle",
        exportPdf = "never"
    }
})
