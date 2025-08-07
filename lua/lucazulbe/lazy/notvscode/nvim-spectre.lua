return {
    "nvim-pack/nvim-spectre",
    build = false,

    config = function()
        local spectre = require('spectre')

        spectre.setup()

        vim.keymap.set("n", "<leader>r", function()
            spectre.open()
        end, { desc = "Replace in project (Spectre)" })
    end,
}
