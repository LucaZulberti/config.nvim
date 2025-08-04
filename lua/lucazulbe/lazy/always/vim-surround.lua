return {
    "tpope/vim-surround",

    config = function ()
        -- Void register
        vim.keymap.set({ "n", "v" }, "<leader>ds", [["_ds]], { desc = "Delete into void register surround" })
        vim.keymap.set({ "n", "v" }, "<leader>cs", [["_cs]], { desc = "Change into void register surround" })
    end
}
