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
function M.replace_word_under_cursor(quick)
    local word = vim.fn.expand("<cword>")
    if word == "" then
        print("No word under cursor")
        return
    end

    local grep_cmd = quick and "vimgrep" or "lvimgrep"
    local target = quick and "**/*" or "%"

    -- Run grep command
    local cmd = string.format('%s /\\<%s\\>/j %s', grep_cmd, word, target)
    vim.cmd(cmd)

    -- Open appropriate list window
    if quick then
        vim.cmd("copen")
    else
        vim.cmd("lopen")
    end

    -- Prepare substitute command
    if quick then
        vim.api.nvim_feedkeys(":cfdo ", "n", false)
    else
        vim.api.nvim_feedkeys(":lfdo ", "n", false)
    end

    -- Add substitution string
    vim.api.nvim_feedkeys(string.format("%%s/\\<%s\\>/%s/gI | update", word, word), "n", false)

    -- Close opened window
    if quick then
        vim.api.nvim_feedkeys(" | cclose ", "n", false)
    else
        vim.api.nvim_feedkeys(" | lclose", "n", false)
    end

    -- Move cursor back to substitution text
    vim.api.nvim_feedkeys(string.rep(M.t("<Left>"), 21), "n", false)
end

return M
