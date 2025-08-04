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

        -- Create select and replace keymaps (1-9)
        for i = 1, 9 do
            local desc = "" .. i
            -- Add the proper ordinal suffix
            if i == 1 then
                desc = desc .. "st"
            elseif i == 2 then
                desc = desc .. "nd"
            elseif i == 3 then
                desc = desc .. "rd"
            else
                desc = desc .. "th"
            end
            desc = desc .. " item in Harpoon list"

            vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end,
                { desc = "Select " .. desc })
            vim.keymap.set("n", "<leader>H" .. i, function() harpoon:list():replace_at(i) end,
                { desc = "Replace " .. desc })
        end

        vim.keymap.set("n", "<leader>P", function() harpoon:list():prev() end,
            { desc = "Select previous item in Harpoon list" })
        vim.keymap.set("n", "<leader>N", function() harpoon:list():next() end,
            { desc = "Select next item in Harpoon list" })
    end
}
