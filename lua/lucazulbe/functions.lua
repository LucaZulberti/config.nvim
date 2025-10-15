local M = {}

-- Convert to Terminal codes
function M.t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.notify_hover(line)
    local width = vim.fn.strdisplaywidth(line)

    -- Create scratch buffer (no file, listed)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { line })

    local opts = {
        relative = 'cursor',
        width = width,
        height = 1,
        col = 1,
        row = 1,
        style = 'minimal',
        border = 'rounded',
    }

    local win = vim.api.nvim_open_win(buf, false, opts)

    -- Define handler ID variable here so we can unregister it inside callback
    local handler_id
    local handler = function()
        -- Close hover window on keypress
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end

        -- Unregister the handler after first keypress
        vim.on_key(nil, handler_id)
    end

    -- Actually register the handler and save the namespace ID for later unregistration
    handler_id = vim.on_key(handler)
end

-- Disable a give keymap
function M.disable_keymap_and_notify(key)
    vim.keymap.set({ 'n', 'v', 'i' }, key, function()
        M.notify_hover("Key " .. key .. " is disabled, use Vim motions!")
    end, { desc = "[General] " .. key .. " is disabled, show reminder", noremap = true, silent = true })
end

-- Use vimgrep or lvimgrep depending on quick boolean parameter
function M.replace_word_under_cursor_or_selection(quick, use_selection)
    local word = ""

    if use_selection then
        -- Save current visual selection
        local old_reg = vim.fn.getreg('"')
        local old_regtype = vim.fn.getregtype('"')

        vim.cmd('normal! "vy') -- yank visual selection into " register
        word = vim.fn.getreg('"')

        -- restore unnamed register
        vim.fn.setreg('"', old_reg, old_regtype)
    else
        word = vim.fn.expand("<cword>")
    end

    if word == "" then
        print("No word or selection found")
        return
    end

    if word == "" then
        print("No word under cursor")
        return
    end

    -- Escape special regex characters in word for literal search
    local word_escaped = vim.fn.escape(word, "\\/.*$^~()[]")

    -- If rg is available, use it; otherwise fallback
    if vim.fn.executable("rg") then
        -- Rg mode depending on selection flag
        local rg_mode = use_selection and "--fixed-strings" or "--word-regexp"
        local rg_word = use_selection and word or word_escaped

        -- Prepare rg command
        local rg_cmd = {
            "rg",
            "--vimgrep",
            rg_mode,
            rg_word,
        }

        -- If not quick (location list mode), restrict to current file
        if not quick then
            table.insert(rg_cmd, vim.fn.expand("%:p"))
        end

        -- Get results from rg invocation
        local results = vim.fn.systemlist(rg_cmd)

        -- Prepare table for inspecting later the items in lists
        local items = {}

        -- Set quickfix list or location list accordingly
        if quick then
            vim.fn.setqflist({}, " ", { title = "Ripgrep", lines = results })
            items = vim.fn.getqflist()
        else
            vim.fn.setloclist(0, {}, " ", { title = "Ripgrep", lines = results })
            items = vim.fn.getloclist(0)
        end

        -- Detect unsaved buffers that match quickfix entries
        local unsaved_files = {}
        local checked_files = {}

        -- For each item in quick or location list
        for _, item in ipairs(items) do
            local filename = item.filename or vim.fn.bufname(item.bufnr or 0)
            if filename ~= "" and not checked_files[filename] then
                local bufnr = vim.fn.bufnr(filename)
                if bufnr ~= -1 then
                    local ok, modified = pcall(vim.api.nvim_get_option_value, "modified", { buf = bufnr })
                    if ok and modified then
                        table.insert(unsaved_files, filename)
                    end
                end
                checked_files[filename] = true
            end
        end

        if #unsaved_files > 0 then
            -- Build warning message
            local msg = "⚠️ Unsaved buffers detected that match your search:\n\n"
                .. table.concat(unsaved_files, "\n")
                .. "\n\nProceed anyway?"

            -- Ask user confirmation (1 = Yes, 2 = No)
            local choice = vim.fn.confirm(msg, "&Yes\n&No", 2, "Warning")

            if choice ~= 1 then
                print("Search/replace aborted to prevent conflicts.")
                return
            end
        end
    else
        -- fallback to vim's builtin vimgrep/lvimgrep
        local grep_cmd = quick and "vimgrep" or "lvimgrep"
        local target = quick and "**/*" or "%"

        local vimgrep_cmd = string.format("%svimgrep", grep_cmd)

        -- Use whole word only if not in selection mode
        if use_selection then
            vimgrep_cmd = string.format("%s /%s/j %s", vimgrep_cmd, word_escaped, target)
        else
            vimgrep_cmd = string.format("%s /\\<%s\\>/j %s", vimgrep_cmd, word_escaped, target)
        end

        -- Run it
        vim.cmd(vimgrep_cmd)
    end

    -- Open appropriate list window
    if quick then
        vim.cmd("copen")
    else
        vim.cmd("lopen")
    end

    -- Prepare substitute command
    local prefix = quick and ":cfdo " or ":lfdo "
    vim.api.nvim_feedkeys(prefix, "n", false)

    -- Add substitution string, using whole word only if not in selection mode
    if use_selection then
        vim.api.nvim_feedkeys(string.format("%%s/%s/%s/gI | update", word, word), "n", false)
    else
        vim.api.nvim_feedkeys(string.format("%%s/\\<%s\\>/%s/gI | update", word, word), "n", false)
    end

    -- Close opened window
    local close_cmd = quick and " | cclose" or " | lclose"
    vim.api.nvim_feedkeys(close_cmd, "n", false)

    -- Move cursor back to substitution text
    vim.api.nvim_feedkeys(string.rep(M.t("<Left>"), 21), "n", false)
end

return M
