return {
    "ntpeters/vim-better-whitespace",

    config = function()
        vim.api.nvim_set_hl(0, 'ExtraWhitespace', { ctermbg = 2 })
    end
}
