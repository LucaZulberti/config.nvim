local funcs = require("lucazulbe.functions")
local rmap = funcs.rmap

-- LSP configuration
-- -----------------

-- Apply defaults to all LSP servers.
vim.lsp.config("*", {
    on_attach = function()
        -- Buffer-local LSP mappings are created when a server attaches.

        -- Formatting is handled externally by conform; keep the native LSP mapping
        -- disabled to avoid duplicate entry points.
        -- map("n", "<leader>lf", vim.lsp.buf.format, { desc = "[LSP] Format current buffer" })

        rmap("n", "<leader>lr", function()
            -- Resolve the current buffer and collect all attached LSP clients.
            local bufnr = vim.api.nvim_get_current_buf()
            local clients = vim.lsp.get_clients({ bufnr = bufnr })

            -- Stop every client attached to this buffer so they can be started again.
            for _, client in ipairs(clients) do
                vim.lsp.stop_client(client.id)
            end

            -- Re-edit the buffer shortly after stopping the clients so filetype-based
            -- startup logic can attach them again.
            vim.defer_fn(function()
                vim.cmd("edit")
            end, 100)
        end, "[LSP] Restart for current buffer")

        rmap("n", "K", function()
            -- Open hover documentation for the symbol under the cursor.
            vim.lsp.buf.hover()
        end, {
            noremap = true,
            silent = true,
            desc = "[LSP] Open information in hover buffer",
        })
    end,
})

-- Configure tinymist for Typst authoring.
vim.lsp.config("tinymist", {
    settings = {
        -- Delegate formatting to typstyle.
        formatterMode = "typstyle",

        -- Disable automatic PDF export from the language server.
        exportPdf = "never",
    },
})

-- Configure remark-ls for Markdown linting.
vim.lsp.config("remark_ls", {
    settings = {
        remark = {
            -- Only enable the server when a project remark configuration is present.
            requireConfig = true,
        },
    },
})

-- Configure PyLSP and delegate linting and formatting to Ruff.
vim.lsp.config("pylsp", {
    settings = {
        pylsp = {
            plugins = {
                -- Disable built-in style and lint providers to avoid overlapping with Ruff.
                pycodestyle = {
                    enabled = false,
                },
                mccabe = {
                    enabled = false,
                },
                pyflakes = {
                    enabled = false,
                },
                autopep8 = {
                    enabled = false,
                },
                yapf = {
                    enabled = false,
                },

                -- Enable Ruff as the single Python linter and formatter backend.
                ruff = {
                    enabled = true,
                    formatEnabled = true,
                    lineLength = 120,
                },
            },
        },
    },
})

-- PyLSP Ruff support
-- ------------------

---Install the python-lsp-ruff plugin into Mason's PyLSP virtual environment.
---
---The plugin is installed only when the Mason-managed python-lsp-server package
---is already present.
local function ensure_pylsp_plugins()
    -- Resolve the Mason installation path for python-lsp-server and its private
    -- virtual environment pip executable.
    local pylsp_path = vim.fn.stdpath("data") .. "/mason/packages/python-lsp-server"
    local venv_pip = pylsp_path .. "/venv/bin/pip"

    -- Install the Ruff plugin only when the Mason package directory exists.
    if vim.fn.isdirectory(pylsp_path) == 1 then
        vim.fn.system(venv_pip .. " install python-lsp-ruff")
    end
end

-- Reinstall the plugin after Mason updates managed tools.
vim.api.nvim_create_autocmd("User", {
    pattern = "MasonToolsUpdateCompleted",
    callback = ensure_pylsp_plugins,
})

-- Also check once during startup in case PyLSP was already installed earlier.
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Defer slightly so Mason and startup initialization can settle first.
        vim.defer_fn(ensure_pylsp_plugins, 100)
    end,
})
