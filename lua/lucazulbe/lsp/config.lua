local M = {}

M.capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities()
)

M.on_attach = function(client, bufnr)
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

return M
