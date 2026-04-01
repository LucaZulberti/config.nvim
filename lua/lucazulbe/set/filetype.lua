vim.filetype.add({
    extension = {
        vh = "verilog",
        v = "verilog",
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "vhdl",
    callback = function()
        vim.opt_local.comments = ":--!,:-- ,:--"
        vim.opt_local.commentstring = "-- %s"
    end,
})
