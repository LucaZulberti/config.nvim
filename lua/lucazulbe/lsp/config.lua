local M = {}

M.capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities()
)

M.on_attach = function(client, bufnr)
    local lz_lsp = require("lucazulbe.lsp")

    -- Search for .workspace-folders file into root dir to load multiple folders in LSP workspace
    lz_lsp.workspace.add_folders_from_file(client.config.root_dir, ".workspace-folders")

    -- Mappings
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- See `:help vim.lsp.*` for documentation on any of the below functions

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts,
        { desc = "Show hover info" }))
    vim.keymap.set('n', '<leader>lK', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts,
        { desc = "Show signature help" }))

    vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, vim.tbl_extend('force', opts,
        { desc = "Jump to definition" }))
    vim.keymap.set('n', '<leader>lD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts,
        { desc = "Jump to declaration" }))
    vim.keymap.set('n', '<leader>lv', '<cmd>vsplit | lua vim.lsp.buf.definition()<CR>',
        vim.tbl_extend('force', opts,
            { desc = "Open definition in vertical split" }))
    vim.keymap.set('n', '<leader>lV', '<cmd>vsplit | lua vim.lsp.buf.declaration()<CR>',
        vim.tbl_extend('force', opts,
            { desc = "Open declaration in vertical split" }))
    vim.keymap.set('n', '<leader>lh', '<cmd>split | lua vim.lsp.buf.definition()<CR>',
        vim.tbl_extend('force', opts,
            { desc = "Open definition in horizzontal split" }))
    vim.keymap.set('n', '<leader>lH', '<cmd>split | lua vim.lsp.buf.declaration()<CR>',
        vim.tbl_extend('force', opts,
            { desc = "Open declaration in horizzontal split" }))
    vim.keymap.set('n', '<leader>lt', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>',
        vim.tbl_extend('force', opts,
            { desc = "Open definition in a new tab" }))
    vim.keymap.set('n', '<leader>lT', '<cmd>tab split | lua vim.lsp.buf.declaration()<CR>',
        vim.tbl_extend('force', opts,
            { desc = "Open declaration in a new tab" }))

    vim.keymap.set('n', '<leader>lrf', vim.lsp.buf.references, vim.tbl_extend('force', opts,
        { desc = "List references of current symbol" }))
    vim.keymap.set('n', '<leader>lrn', vim.lsp.buf.rename, vim.tbl_extend('force', opts,
        { desc = "Rename current symbol" }))
    vim.keymap.set('n', '<leader>lca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts,
        { desc = "List code actions" }))

    vim.keymap.set('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend('force', opts,
        { desc = "Add working directory or current folder to workspace list" }))
    vim.keymap.set('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend('force', opts,
        { desc = "Remove working directory or current folder to workspace list" }))
    vim.keymap.set('n', '<leader>lwl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, vim.tbl_extend('force', opts,
        { desc = "List workspace folders" }))
end

return M
