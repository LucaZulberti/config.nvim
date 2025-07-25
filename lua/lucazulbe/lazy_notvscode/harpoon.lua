return {
    'ThePrimeagen/harpoon',

    branch = "harpoon2",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        -- basic telescope configuration
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            }):find()
        end

        vim.keymap.set("n", "<leader>h", function() toggle_telescope(harpoon:list()) end,
            { desc = "Open Harpoon window" })

        vim.keymap.set("n", "<leader>A", function() harpoon:list():prepend() end,
            { desc = "Prepend entry in Harpoon list" })
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end,
            { desc = "Add entry in Harpoon list" })

        vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end,
            { desc = "Select 1st item in Harpoon list" })
        vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end,
            { desc = "Select 2nd item in Harpoon list" })
        vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end,
            { desc = "Select 3rd item in Harpoon list" })
        vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end,
            { desc = "Select 4th item in Harpoon list" })

        vim.keymap.set("n", "<leader>w1", function() harpoon:list():replace_at(1) end,
            { desc = "Replace 1st item in Harpoon list" })
        vim.keymap.set("n", "<leader>w2", function() harpoon:list():replace_at(2) end,
            { desc = "Replace 2nd item in Harpoon list" })
        vim.keymap.set("n", "<leader>w3", function() harpoon:list():replace_at(3) end,
            { desc = "Replace 3rd item in Harpoon list" })
        vim.keymap.set("n", "<leader>w4", function() harpoon:list():replace_at(4) end,
            { desc = "Replace 4th item in Harpoon list" })

        vim.keymap.set("n", "<leader>P", function() harpoon:list():prev() end,
            { desc = "Select previous item in Harpoon list" })
        vim.keymap.set("n", "<leader>N", function() harpoon:list():next() end,
            { desc = "Select next item in Harpoon list" })
    end
}
