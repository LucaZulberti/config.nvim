return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",

    init = function()
        vim.g.mkdp_filetypes = { "markdown" }
    end,

    ft = { "markdown" },

    config = function()
        vim.api.nvim_set_keymap('n', '<leader>p', '<cmd>MarkdownPreviewToggle<CR>',
            { noremap = true, silent = true, desc = "Toggle markdown preview" })
    end,
}
