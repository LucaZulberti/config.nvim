local funcs = require("lucazulbe.functions")
local rmap = funcs.rmap

local h = require("tv").handlers

require("tv").setup {
    -- global window appearance (can be overridden per channel)
    window = {
        width = 0.8,  -- 80% of editor width
        height = 0.8, -- 80% of editor height
        border = "none",
        title = " tv.nvim ",
        title_pos = "center",
    },
    -- per-channel configurations
    channels = {
        -- Fuzzy find files in your project
        files = {
            keybinding = "<leader>pf", -- Launch the files channel
            -- what happens when you press a key
            handlers = {
                ["<CR>"] = h.open_as_files,      -- default: open selected files
                ["<C-q>"] = h.send_to_quickfix,  -- send to quickfix list
                ["<C-s>"] = h.open_in_split,     -- open in horizontal split
                ["<C-v>"] = h.open_in_vsplit,    -- open in vertical split
                ["<C-y>"] = h.copy_to_clipboard, -- copy paths to clipboard
            },
        },

        -- Ripgrep search through file contents
        text = {
            keybinding = "<leader><leader>",
            handlers = {
                ["<CR>"] = h.open_at_line,       -- Jump to line:col in file
                ["<C-q>"] = h.send_to_quickfix,  -- Send matches to quickfix
                ["<C-s>"] = h.open_in_split,     -- Open in horizontal split
                ["<C-v>"] = h.open_in_vsplit,    -- Open in vertical split
                ["<C-y>"] = h.copy_to_clipboard, -- Copy matches to clipboard
            },
        },

        -- Fuzzy find git files in your project
        ["git-files"] = {
            keybinding = "<leader>pgf", -- Launch the files channel
            -- what happens when you press a key
            handlers = {
                ["<CR>"] = h.open_as_files,      -- default: open selected files
                ["<C-q>"] = h.send_to_quickfix,  -- send to quickfix list
                ["<C-s>"] = h.open_in_split,     -- open in horizontal split
                ["<C-v>"] = h.open_in_vsplit,    -- open in vertical split
                ["<C-y>"] = h.copy_to_clipboard, -- copy paths to clipboard
            },
        },

        -- Browse git commit history
        ["git-log"] = {
            keybinding = "<leader>pgl",
            handlers = {
                -- custom handler: show commit diff in scratch buffer
                ["<CR>"] = function(entries, config)
                    if #entries > 0 then
                        vim.cmd("enew | setlocal buftype=nofile bufhidden=wipe")
                        vim.cmd("silent 0read !git show " .. vim.fn.shellescape(entries[1]))
                        vim.cmd("1delete _ | setlocal filetype=git nomodifiable")
                        vim.cmd("normal! gg")
                    end
                end,
                -- copy commit hash to clipboard
                ["<C-y>"] = h.copy_to_clipboard,
            },
        },

        -- Browse git branches
        ["git-branch"] = {
            keybinding = "<leader>pgb",
            handlers = {
                -- checkout branch using execute_shell_command helper
                -- {} is replaced with the selected entry
                ["<CR>"] = h.execute_shell_command("git checkout {}"),
                ["<C-y>"] = h.copy_to_clipboard,
            },
        },

        -- Browse git reflog
        ["git-reflog"] = {
            keybinding = "<leader>pgr",
            handlers = {
                -- custom handler: show commit diff in scratch buffer
                ["<CR>"] = function(entries, config)
                    if #entries > 0 then
                        vim.cmd("enew | setlocal buftype=nofile bufhidden=wipe")
                        vim.cmd("silent 0read !git show " .. vim.fn.shellescape(entries[1]))
                        vim.cmd("1delete _ | setlocal filetype=git nomodifiable")
                        vim.cmd("normal! gg")
                    end
                end,
                -- copy commit hash to clipboard
                ["<C-y>"] = h.copy_to_clipboard,
            },
        },

        -- Search environment variables
        env = {
            keybinding = "<leader>pe",
            handlers = {
                ["<CR>"] = h.insert_at_cursor,    -- Insert at cursor position
                ["<C-l>"] = h.insert_on_new_line, -- Insert on new line
                ["<C-y>"] = h.copy_to_clipboard,
            },
        },

        -- `aliases`: search shell aliases
        alias = {
            keybinding = "<leader>pa",
            handlers = {
                ["<CR>"] = h.insert_at_cursor,
                ["<C-y>"] = h.copy_to_clipboard,
            },
        },
    },
    -- path to the tv binary (default: 'tv')
    tv_binary = "tv",
    global_keybindings = {
        channels = "<leader>tv", -- opens the channel selector
    },
    quickfix = {
        auto_open = true, -- automatically open quickfix window after populating
    },
}

rmap("n", "<leader>pgw", ":Tv git-worktrees<CR>", "Tv: Git Worktrees")
rmap("n", "<leader>pt", ":Tv tmux-sessions<CR>", "Tv: Tmux Sessions")

-- rmap("n", "<leader>ph", ":Pick help<CR>", "[Mini.Pick] Help")
-- rmap("n", "<leader>pd", ":Pick diagnostic<CR>", "[Mini.Pick] Diagnostic")
-- rmap("n", "<leader>plq", ":Pick list scope='quickfix'<CR>", "[Mini.Pick] Quickfix List")
-- rmap("n", "<leader>pll", ":Pick list scope='location'<CR>", "[Mini.Pick] Location List")
-- rmap("n", "<leader>plj", ":Pick list scope='jump'<CR>", "[Mini.Pick] Jump List")
-- rmap("n", "<leader>plc", ":Pick list scope='change'<CR>", "[Mini.Pick] Change List")
-- rmap("n", "<leader>pm", ":Pick marks<CR>", "[Mini.Pick] Marks")
-- rmap("n", "<leader>pr", ":Pick registers<CR>", "[Mini.Pick] Registers")
-- rmap("n", "<leader>pk", ":Pick keymaps<CR>", "[Mini.Pick] Keymaps")
