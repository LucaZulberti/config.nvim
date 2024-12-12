return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({})

        local builtin = require('telescope.builtin')

        -- Find
        vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Project find files" })
        vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Git find files" })

        -- Search
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, { desc = "Project search" })
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, { desc = "Project search word" })
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, { desc = "Project search WORD" })

        -- Help
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "Visual help" })
    end
}
