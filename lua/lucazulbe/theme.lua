-- Active window background
vim.api.nvim_create_autocmd("WinEnter", {
    pattern = "*",
    callback = function()
        vim.opt_local.winhighlight = "Normal:Normal"
    end
})

-- Inactive window background
vim.api.nvim_create_autocmd("WinLeave", {
    pattern = "*",
    callback = function()
        vim.opt_local.winhighlight = "Normal:FloatBorder"
    end
})
