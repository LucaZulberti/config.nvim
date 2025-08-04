return {
    "Eandrju/cellular-automaton.nvim",

    config = function ()
        vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Make it rain" });
    end
}
