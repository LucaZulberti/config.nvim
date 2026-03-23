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

function M.move_vsep(offset)
    local cur = vim.fn.winnr()
    local left = vim.fn.winnr("h")
    local right = vim.fn.winnr("l")

    -- No vertical split here.
    if left == cur and right == cur then
        return
    end

    if offset < 0 then
        -- Move a separator left.
        if left ~= cur then
            -- Move current window's left border.
            vim.fn.win_move_separator(left, offset)
        else
            -- No left border: move current window's right border.
            vim.fn.win_move_separator(cur, offset)
        end
    else
        -- Move a separator right.
        if right ~= cur then
            -- Move current window's right border.
            vim.fn.win_move_separator(cur, offset)
        else
            -- No right border: move current window's left border.
            vim.fn.win_move_separator(left, offset)
        end
    end
end

function M.move_hsep(offset)
    local cur = vim.fn.winnr()
    local up = vim.fn.winnr("k")
    local down = vim.fn.winnr("j")

    -- No horizontal split here.
    if up == cur and down == cur then
        return
    end

    if offset < 0 then
        -- Move a separator up.
        if up ~= cur then
            -- Move current window's top border.
            vim.fn.win_move_statusline(up, offset)
        else
            -- No top border: move current window's bottom border.
            vim.fn.win_move_statusline(cur, offset)
        end
    else
        -- Move a separator down.
        if down ~= cur then
            -- Move current window's bottom border.
            vim.fn.win_move_statusline(cur, offset)
        else
            -- No bottom border: move current window's top border.
            vim.fn.win_move_statusline(up, offset)
        end
    end
end

function M.resize_current_width(delta)
    vim.cmd(("vertical resize %s%d"):format(delta > 0 and "+" or "-", math.abs(delta)))
end

function M.resize_current_height(delta)
    vim.cmd(("resize %s%d"):format(delta > 0 and "+" or "-", math.abs(delta)))
end

-- Helper: capture the current visual selection without clobbering the unnamed
-- register. This keeps the function safe during normal editing sessions.
local function get_visual_selection()
    local old_reg = vim.fn.getreg('"')
    local old_regtype = vim.fn.getregtype('"')

    vim.cmd('normal! "vy')
    local text = vim.fn.getreg('"')

    vim.fn.setreg('"', old_reg, old_regtype)
    return text
end

-- Helper: choose a substitute delimiter that does not appear in the pattern or
-- replacement. This reduces escaping noise in the generated command line.
local function pick_delim(...)
    local candidates = { "/", "#", "@", "|", ";", ":" }

    for _, d in ipairs(candidates) do
        local ok = true
        for i = 1, select("#", ...) do
            local s = tostring(select(i, ...))
            if s:find(d, 1, true) then
                ok = false
                break
            end
        end
        if ok then
            return d
        end
    end

    return "/"
end

-- Helper: escape only the chosen Ex delimiter.
local function escape_for_delim(text, delim)
    return text:gsub(vim.pesc(delim), "\\" .. delim)
end

-- Helper: turn plain text into a literal Vim pattern using \V.
-- Used for selection mode, where regex semantics are not wanted.
local function vim_literal_pattern(text, delim)
    text = text:gsub("\\", "\\\\")
    text = escape_for_delim(text, delim)
    return "\\V" .. text
end

-- Helper: escape replacement text for the replacement side of :substitute.
local function escape_sub_replacement(text, delim)
    text = text:gsub("\\", "\\\\")
    text = text:gsub("&", "\\&")
    text = escape_for_delim(text, delim)
    return text
end

-- Helper: get the active result list depending on search scope.
local function get_result_list(quick)
    return quick and vim.fn.getqflist() or vim.fn.getloclist(0)
end

-- Helper: clear the active result list to avoid stale matches being reused.
local function clear_result_list(quick)
    if quick then
        vim.fn.setqflist({}, "r", { items = {} })
    else
        vim.fn.setloclist(0, {}, "r", { items = {} })
    end
end

-- Helper: inspect current quickfix/location-list entries and warn if any
-- matching file is also open and modified in memory.
local function warn_if_modified_matches(quick)
    local items = get_result_list(quick)
    local unsaved_files = {}
    local checked_files = {}

    for _, item in ipairs(items) do
        local filename = item.filename or vim.fn.bufname(item.bufnr or 0)

        if filename ~= "" and not checked_files[filename] then
            local bufnr = vim.fn.bufnr(filename)

            if bufnr ~= -1 then
                local ok, modified = pcall(
                    vim.api.nvim_get_option_value,
                    "modified",
                    { buf = bufnr }
                )
                if ok and modified then
                    table.insert(unsaved_files, filename)
                end
            end

            checked_files[filename] = true
        end
    end

    if #unsaved_files > 0 then
        local msg = "Unsaved buffers detected that match your search:\n\n"
            .. table.concat(unsaved_files, "\n")
            .. "\n\nProceed anyway?"

        local choice = vim.fn.confirm(msg, "&Yes\n&No", 2, "Warning")
        if choice ~= 1 then
            vim.notify("Search/replace aborted to prevent conflicts.", vim.log.levels.WARN)
            return false
        end
    end

    return true
end

-- Run :vimgrep / :lvimgrep safely.
--
-- Returns:
--   true  -> search completed and the result list is non-empty
--   false -> no matches or command failure
local function run_vimgrep_safe(quick, search_pattern)
    local grep_cmd = quick and "vimgrep" or "lvimgrep"
    local target = quick and "**/*" or "%"

    -- Only the command delimiter must be escaped here; the pattern itself stays
    -- a Vim regex.
    local grep_pattern = escape_for_delim(search_pattern, "/")
    local cmd = string.format("%s /%s/gj %s", grep_cmd, grep_pattern, target)

    -- Catch command errors thrown by vim.cmd(), including E480 "No match".
    local ok, err = pcall(vim.cmd, cmd)
    if not ok then
        local err_s = tostring(err)

        -- Clear the active list so stale results are not reused accidentally.
        clear_result_list(quick)

        if err_s:match("E480: No match:") then
            vim.notify(
                quick and "No matches found in all files" or "No matches found in current file",
                vim.log.levels.WARN
            )
            return false
        end

        -- Common regex syntax failures.
        if err_s:match("E54:") or err_s:match("E55:") then
            vim.notify("Invalid Vim regex: " .. search_pattern, vim.log.levels.WARN)
            return false
        end

        vim.notify("Search failed: " .. err_s, vim.log.levels.ERROR)
        return false
    end

    -- Defensive check: even without an exception, avoid proceeding with an empty list.
    local items = get_result_list(quick)
    if vim.tbl_isempty(items) then
        clear_result_list(quick)
        vim.notify(
            quick and "No matches found in all files" or "No matches found in current file",
            vim.log.levels.WARN
        )
        return false
    end

    return true
end

-- Core implementation shared by all public entry points.
--
-- Parameters:
--   quick            boolean
--       true  -> use quickfix and search recursively in all files (**/*)
--       false -> use location list and search only in the current file (%)
--
--   search_pattern   string
--       Vim regex used by :vimgrep / :lvimgrep
--
--   replacement_seed string
--       Initial text placed into the replacement field of the generated
--       :substitute command
--
--   literal_mode     boolean
--       true  -> rebuild substitute pattern literally from replacement_seed
--       false -> use search_pattern as a regex in :substitute too
local function search_and_prepare_replace(quick, search_pattern, replacement_seed, literal_mode)
    if search_pattern == nil or search_pattern == "" then
        vim.notify("Empty search pattern", vim.log.levels.WARN)
        return
    end

    if not run_vimgrep_safe(quick, search_pattern) then
        return
    end

    local items = get_result_list(quick)

    if vim.tbl_isempty(items) then
        clear_result_list(quick)
        vim.notify(
            quick and "No matches found in all files" or "No matches found in current file",
            vim.log.levels.WARN
        )
        return
    end

    if not warn_if_modified_matches(quick) then
        return
    end

    if quick then
        vim.cmd("copen")
    else
        vim.cmd("lopen")
    end

    local delim = pick_delim(search_pattern, replacement_seed)

    -- For selection mode, rebuild the substitute pattern literally from the
    -- selected text. For regex modes, preserve the Vim regex as entered.
    local sub_pattern
    if literal_mode then
        sub_pattern = vim_literal_pattern(replacement_seed, delim)
    else
        sub_pattern = escape_for_delim(search_pattern, delim)
    end

    local sub_replacement = escape_sub_replacement(replacement_seed, delim)

    local prefix = quick and ":cfdo " or ":lfdo "
    local close_cmd = quick and " | cclose" or " | lclose"

    -- Use:
    --   g -> replace all matches on each line
    --   I -> case-sensitive
    --   e -> do not error if one file no longer matches during cfdo/lfdo
    --
    -- keeppatterns avoids polluting the user's last search pattern while the
    -- bulk substitute executes.
    local sub_cmd = string.format(
        "keeppatterns %%s%s%s%s%s%sgIe | update%s",
        delim,
        sub_pattern,
        delim,
        sub_replacement,
        delim,
        close_cmd
    )

    -- Prefill the command line instead of executing immediately.
    vim.api.nvim_feedkeys(prefix .. sub_cmd, "n", false)

    -- Leave the cursor inside the replacement field for ergonomic editing.
    local left = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
    local suffix_after_replacement = delim .. "gIe | update" .. close_cmd
    vim.api.nvim_feedkeys(left:rep(#suffix_after_replacement), "n", false)
end

-- Public API: use the current visual selection as a literal pattern.
--
-- Example:
--   M.replace_selection(true)  -> selection across all files
--   M.replace_selection(false) -> selection in current file
function M.replace_selection(quick)
    local sel = get_visual_selection()
    if sel == "" then
        vim.notify("No selection found", vim.log.levels.WARN)
        return
    end

    local search_pattern = vim_literal_pattern(sel, "/")
    search_and_prepare_replace(quick, search_pattern, sel, true)
end

-- Public API: prompt for a Vim regex, initialized from the last search pattern.
--
-- This is useful when you want to tweak @/ but do not need native /-style live
-- preview while typing.
function M.replace_prompted_regex(quick)
    local last_search = vim.fn.getreg("/")
    local input = vim.fn.input("Regex: ", last_search)

    if input == nil or input == "" then
        vim.notify("Empty regex, aborted", vim.log.levels.WARN)
        return
    end

    -- Keep @/ aligned with what the user typed so n/N and later searches feel natural.
    vim.fn.setreg("/", input)

    search_and_prepare_replace(quick, input, "", false)
end

-- Public API: use the current search register (@/) directly.
--
-- Intended workflow:
--   1. Type /... and refine interactively with incsearch enabled
--   2. Press <CR>
--   3. Call this function
function M.replace_last_search(quick)
    local pattern = vim.fn.getreg("/")

    if pattern == nil or pattern == "" then
        vim.notify("No previous search pattern", vim.log.levels.WARN)
        return
    end

    search_and_prepare_replace(quick, pattern, "", false)
end

-- Compatibility wrapper preserving the old public function name.
--
-- Revised behavior:
--   use_selection = true  -> literal visual selection
--   use_selection = false -> prompted Vim regex initialized from @/
function M.replace_word_under_cursor_or_selection(quick, use_selection)
    if use_selection then
        M.replace_selection(quick)
    else
        M.replace_prompted_regex(quick)
    end
end

return M
