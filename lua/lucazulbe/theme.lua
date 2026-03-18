-- Appearance
vim.cmd("colorscheme catppuccin-mocha")
vim.cmd(":hi statusline guibg=NONE")

-- Active window
vim.api.nvim_create_autocmd("WinEnter", {
    pattern = "*",
    callback = function()
        vim.opt_local.winhighlight = "Normal:NormalFloat,StatusLine:NormalFloat,StatusLineNC:Normal"
    end
})

-- Inactive window
vim.api.nvim_create_autocmd("WinLeave", {
    pattern = "*",
    callback = function()
        vim.opt_local.winhighlight = "Normal:Normal,StatusLine:Normal,StatusLineNC:Normal"
    end
})
