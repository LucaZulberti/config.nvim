return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })

        local LucaZulbe_Fugitive = vim.api.nvim_create_augroup("LucaZulbe_Fugitive", {})

        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = LucaZulbe_Fugitive,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = { buffer = bufnr, remap = false }

                -- Common operations
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git('push')
                end, vim.tbl_extend("force", opts, { desc = "Git push" }))
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({ 'pull', '--rebase' })
                end, vim.tbl_extend("force", opts, { desc = "Git pull with rebase" }))
                vim.keymap.set("n", "<leader>t", ":Git push -u origin ",
                    vim.tbl_extend("force", opts, { desc = "Git push and track origin" }))
            end,
        })

        vim.keymap.set("n", "gf", "<cmd>diffget //2<CR>", { desc = "Get right diff" })
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>", { desc = "Get left diff" })
    end
}
