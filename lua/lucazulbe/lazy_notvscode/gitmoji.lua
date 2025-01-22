return {
    "LucaZulberti/neo-gitmoji.nvim",
    branch = "emoji_code",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {},
    config = function()
        local function change_directory_and_run_gitmoji()
            local start_neo_gitmoji = require("neo-gitmoji").open_floating

            -- Change the directory by removing the 'fugitive://' prefix
            vim.cmd("execute 'lcd' '" .. vim.fn.substitute(vim.fn.expand('%:p:h'), 'fugitive://', '', '') .. "'")

            -- Start NeoGitmoji
            start_neo_gitmoji()
        end

        -- Set the keybinding
        vim.keymap.set('n', '<leader>gm', function() change_directory_and_run_gitmoji() end,
            { desc = "Gitmoji in current directory", noremap = true, silent = true })
    end
}
