local M = {}

-- Convert to Terminal codes
function M.t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Notify Vim-Motion practice
function M.notify_practice()
    vim.cmd('echohl WarningMsg')
    vim.cmd([[echom "You need to practice Vim-Motions!!!"]])
    vim.cmd('echohl None')
end

-- Disable a give keymap
function M.disable_keymap(key)
    -- For insert mode, show message and stay in insert mode
    vim.keymap.set('i', key, function()
        -- Exit insert, show message, re-enter insert
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
        M.notify_practice()
        vim.api.nvim_feedkeys('i', 'n', false)
    end, opts)

    -- For normal and visual modes just show message
    vim.keymap.set({ 'n', 'v' }, key, M.notify_practice, opts)
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
