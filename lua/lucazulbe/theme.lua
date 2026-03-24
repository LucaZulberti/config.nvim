-- Colors and window highlights
-- ----------------------------

-- Apply the colorscheme and keep the statusline background transparent.
vim.cmd("colorscheme catppuccin-mocha")
vim.cmd("hi statusline guibg=NONE")

local active_winhighlight =
"Normal:NormalFloat,StatusLine:NormalFloat,StatusLineNC:Normal"

local inactive_winhighlight =
"Normal:Normal,StatusLine:Normal,StatusLineNC:Normal"

-- Active window
-- -------------

vim.api.nvim_create_autocmd("WinEnter", {
    pattern = "*",
    callback = function()
        -- Use the active-window highlight set when entering a window.
        vim.opt_local.winhighlight = active_winhighlight
    end,
})

-- Inactive window
-- ---------------

vim.api.nvim_create_autocmd("WinLeave", {
    pattern = "*",
    callback = function()
        -- Restore the inactive-window highlight set when leaving a window.
        vim.opt_local.winhighlight = inactive_winhighlight
    end,
})

-- ColorColumn
-- -----------

local colorcolumns = {
    vhdl = "100",
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local cc = colorcolumns[ft]

        if cc ~= nil then
            vim.opt_local.colorcolumn = cc
        end
    end,
})
