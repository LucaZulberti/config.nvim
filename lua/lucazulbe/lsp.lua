-- Shortcut
local map = vim.keymap.set

-- Configure each LSP
-- ------------------

vim.lsp.config("*", {
    on_attach = function()
        -- Add LSP commands
        -- ----------------

        -- Format with conform in pack.lua
        -- map('n', '<leader>lf', vim.lsp.buf.format, { desc = "[LSP] Format current buffer" })

        map('n', '<leader>lr', function()
            local bufnr = vim.api.nvim_get_current_buf()
            local clients = vim.lsp.get_clients({ bufnr = bufnr })

            for _, client in ipairs(clients) do
                vim.lsp.stop_client(client.id)
            end

            vim.defer_fn(function()
                vim.cmd("edit") -- re-edit buffer to retrigger LSP attachment
            end, 100)
        end, { desc = "[LSP] Restart for current buffer" })

        map('n', 'K', function() vim.lsp.buf.hover() end,
            { noremap = true, silent = true, desc = "[LSP] Open information in hover buffer" })
    end
})

vim.lsp.config("tinymist", {
    settings = {
        formatterMode = "typstyle",
        exportPdf = "never"
    }
})

vim.lsp.config("remark_ls", {
    settings = {
        remark = {
            requireConfig = true,
        }

    }
})

vim.lsp.config("pylsp", {
    settings = {
        pylsp = {
            plugins = {
                -- Disable default formatters/linters
                pycodestyle = {
                    enabled = false
                },
                mccabe = {
                    enabled = false
                },
                pyflakes = {
                    enabled = false
                },
                autopep8 = {
                    enabled = false
                },
                yapf = {
                    enabled = false
                },

                -- Enable Ruff
                ruff = {
                    enabled = true,
                    formatEnabled = true, -- Enable formatting
                    lineLength = 120,
                },
            }
        }
    }
})

-- For PyLSP using Ruff
-----------------------

-- Check if python-lsp-server and the python-lsp-ruff plugin are installed
local function ensure_pylsp_plugins()
    local pylsp_path = vim.fn.stdpath("data") .. "/mason/packages/python-lsp-server"
    local venv_pip = pylsp_path .. "/venv/bin/pip"

    -- Check if pylsp is installed
    if vim.fn.isdirectory(pylsp_path) == 1 then
        -- Install python-lsp-ruff
        vim.fn.system(venv_pip .. " install python-lsp-ruff")
    end
end

-- Run after Mason is loaded
vim.api.nvim_create_autocmd("User", {
    pattern = "MasonToolsUpdateCompleted",
    callback = ensure_pylsp_plugins,
})

-- Also run on VimEnter in case it's already installed
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.defer_fn(ensure_pylsp_plugins, 100)
    end,
})
