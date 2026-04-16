local funcs = require("lucazulbe.functions")
local rmap = funcs.rmap

local telescope = require("telescope")
local builtin = require("telescope.builtin")
local lga_actions = require("telescope-live-grep-args.actions")

telescope.setup {
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key"
            }
        }
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
        live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = {         -- extend mappings
                i = {
                    ["<M-k>"] = lga_actions.quote_prompt(),
                    ["<M-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                    -- freeze the current list and start a fuzzy search in the frozen list
                    ["<C-space>"] = lga_actions.to_fuzzy_refine,
                },
            },
            -- ... also accepts theme settings, for example:
            -- theme = "dropdown", -- use dropdown theme
            -- theme = { }, -- use own theme spec
            layout_config = { mirror = true }, -- mirror preview pane
        },
        file_browser = {
            theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
                ["i"] = {
                    -- your custom insert mode mappings
                },
                ["n"] = {
                    -- your custom normal mode mappings
                },
            },
        },
    }
}

telescope.load_extension("live_grep_args")
telescope.load_extension("frecency")
telescope.load_extension("file_browser")

-- Files
rmap('n', '<leader>pf', builtin.find_files, { desc = '[Telescope] find files' })
-- rmap('n', '<leader>ps', builtin.live_grep, { desc = '[Telescope] live grep' })
rmap('n', '<leader>pz', builtin.current_buffer_fuzzy_find, { desc = '[Telescope] buffer fzf' })

-- Git
rmap('n', '<leader>pgf', builtin.git_files, { desc = '[Telescope] git files' })
rmap('n', '<leader>pgc', builtin.git_commits, { desc = '[Telescope] git commits' })
rmap('n', '<leader>pgC', builtin.git_bcommits, { desc = '[Telescope] git this buffer commits' })
rmap('n', '<leader>pgb', builtin.git_branches, { desc = '[Telescope] git branches' })
rmap('n', '<leader>pgs', builtin.git_status, { desc = '[Telescope] git status' })

-- LSP
rmap('n', '<leader>lr', builtin.lsp_references, { desc = '[Telescope] lsp references' })
rmap('n', '<leader>ld', builtin.lsp_definitions, { desc = '[Telescope] lsp definitions' })
rmap('n', '<leader>lt', builtin.lsp_type_definitions, { desc = '[Telescope] lsp type definitions' })
rmap('n', '<leader>ls', builtin.lsp_document_symbols, { desc = '[Telescope] lsp document symbols' })
rmap('n', '<leader>lS', builtin.lsp_workspace_symbols, { desc = '[Telescope] lsp workspace symbols' })
rmap('n', '<leader>pd', function() builtin.diagnostics { bufnr = 0 } end, { desc = '[Telescope] lsp buffer diagnostics' })
rmap('n', '<leader>pD', builtin.diagnostics, { desc = '[Telescope] lsp workspace diagnostics' })
rmap('n', '<leader>li', builtin.lsp_incoming_calls, { desc = '[Telescope] lsp incoming calls' })
rmap('n', '<leader>lo', builtin.lsp_outgoing_calls, { desc = '[Telescope] lsp outgoing calls' })

-- Vim
rmap('n', '<leader>pb', builtin.buffers, { desc = '[Telescope] buffers' })
rmap('n', '<leader>pc', builtin.commands, { desc = '[Telescope] commands' })
rmap('n', '<leader>pC', builtin.command_history, { desc = '[Telescope] command history' })
rmap('n', '<leader>pm', builtin.marks, { desc = '[Telescope] marks' })
rmap('n', '<leader>pr', builtin.registers, { desc = '[Telescope] registers' })
rmap('n', '<leader>pq', builtin.quickfix, { desc = '[Telescope] quickfix' })
rmap('n', '<leader>pl', builtin.loclist, { desc = '[Telescope] location list' })
rmap('n', '<leader>po', builtin.oldfiles, { desc = '[Telescope] old files' })
rmap('n', '<leader>pk', builtin.keymaps, { desc = '[Telescope] keymaps' })
rmap('n', '<leader>ph', builtin.help_tags, { desc = '[Telescope] help tags' })

-- Telescope
rmap('n', '<leader>p.', builtin.resume, { desc = '[Telescope] resume' })
rmap('n', '<leader>p?', builtin.builtin, { desc = '[Telescope] builtin' })

-- Extensions
rmap('n', '<leader>ps', telescope.extensions.live_grep_args.live_grep_args, { desc = '[Telescope] live grep' })
rmap('n', '<leader>pr', telescope.extensions.frecency.frecency, { desc = '[Telescope] frecency' })
rmap('n', '<leader>pe',
    function() telescope.extensions.file_browser.file_browser { path = "%:p:h", select_buffer = true } end,
    { desc = '[Telescope] file browser' })
rmap('n', '<leader>p@', builtin.symbols, { desc = '[Telescope] symbols' })
