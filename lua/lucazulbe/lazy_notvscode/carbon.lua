return {
    'SidOfc/carbon.nvim',

    dependencies = {
        "nvim-telescope/telescope.nvim"
    },

    config = function()
        require('carbon').setup({
            auto_open = false
        })

        vim.keymap.set("n", "<leader>b", "<cmd>ToggleSidebarCarbon<CR>", { desc = "Toggle Carbon sidebar" })
    end
}
