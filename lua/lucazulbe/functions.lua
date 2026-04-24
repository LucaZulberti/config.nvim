local M = {}

-- Shortcut for defining keymaps.
local map = vim.keymap.set

---Define a keymap with either a description string or a full options table.
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts_or_desc? string|table
function M.rmap(mode, lhs, rhs, opts_or_desc)
    local opts

    if type(opts_or_desc) == "string" then
        -- Treat a string as the mapping description.
        opts = { desc = opts_or_desc }
    elseif type(opts_or_desc) == "table" then
        -- Copy user options so this helper never mutates the caller's table.
        opts = vim.tbl_extend("keep", {}, opts_or_desc)
    elseif opts_or_desc == nil then
        -- Allow the helper to be used without extra options.
        opts = {}
    else
        error("rmap: fourth argument must be a string, table, or nil")
    end

    -- Forward the normalized options table to vim.keymap.set.
    map(mode, lhs, rhs, opts)
end

---Convert a key string to terminal codes.
---@param str string
---@return string
function M.t(str)
    -- Expand special key notation such as <CR>, <Esc>, or <C-w> into the
    -- terminal codes expected by Neovim input APIs.
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

---Show a one-line floating notification near the cursor until the next keypress.
---@param line string
function M.notify_hover(line)
    -- Compute the displayed width so the floating window fits the rendered text.
    local width = vim.fn.strdisplaywidth(line)

    -- Create an unlisted scratch buffer and write the message into it.
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { line })

    -- Place a minimal floating window next to the cursor.
    local opts = {
        relative = "cursor",
        width = width,
        height = 1,
        col = 1,
        row = 1,
        style = "minimal",
        border = "rounded",
    }

    -- Open the floating window without entering it.
    local win = vim.api.nvim_open_win(buf, false, opts)

    -- Store the handler id so the callback can unregister itself after firing.
    local handler_id
    local handler = function()
        -- Close the floating window if it still exists.
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end

        -- Remove the temporary key handler after the first keypress.
        vim.on_key(nil, handler_id)
    end

    -- Register the one-shot key handler.
    handler_id = vim.on_key(handler)
end

---Disable a keymap in normal, visual, and insert mode and show a reminder.
---@param key string
function M.disable_keymap_and_notify(key)
    -- Override the key in the main editing modes and replace it with a reminder.
    vim.keymap.set({ "n", "v", "i" }, key, function()
        M.notify_hover("Key " .. key .. " is disabled, use Vim motions!")
    end, {
        desc = "[General] " .. key .. " is disabled, show reminder",
        noremap = true,
        silent = true,
    })
end

---Move a vertical window separator left or right.
---
---The function tries to move the separator that matches the requested visual
---direction rather than merely resizing the current window.
---@param offset integer Negative moves left, positive moves right.
function M.move_vsep(offset)
    -- Identify the current window and its horizontal neighbors.
    local cur = vim.fn.winnr()
    local left = vim.fn.winnr("h")
    local right = vim.fn.winnr("l")

    -- Abort when there is no vertical split in this layout.
    if left == cur and right == cur then
        return
    end

    if offset < 0 then
        -- Moving left means preferring the current window's left border when it
        -- exists. If there is no left neighbor, move the right border instead.
        if left ~= cur then
            vim.fn.win_move_separator(left, offset)
        else
            vim.fn.win_move_separator(cur, offset)
        end
    else
        -- Moving right means preferring the current window's right border when it
        -- exists. If there is no right neighbor, move the left border instead.
        if right ~= cur then
            vim.fn.win_move_separator(cur, offset)
        else
            vim.fn.win_move_separator(left, offset)
        end
    end
end

---Move a horizontal window separator up or down.
---
---The function tries to move the separator that matches the requested visual
---direction rather than merely resizing the current window.
---@param offset integer Negative moves up, positive moves down.
function M.move_hsep(offset)
    -- Identify the current window and its vertical neighbors.
    local cur = vim.fn.winnr()
    local up = vim.fn.winnr("k")
    local down = vim.fn.winnr("j")

    -- Abort when there is no horizontal split in this layout.
    if up == cur and down == cur then
        return
    end

    if offset < 0 then
        -- Moving up means preferring the current window's top border when it
        -- exists. If there is no upper neighbor, move the bottom border instead.
        if up ~= cur then
            vim.fn.win_move_statusline(up, offset)
        else
            vim.fn.win_move_statusline(cur, offset)
        end
    else
        -- Moving down means preferring the current window's bottom border when it
        -- exists. If there is no lower neighbor, move the top border instead.
        if down ~= cur then
            vim.fn.win_move_statusline(cur, offset)
        else
            vim.fn.win_move_statusline(up, offset)
        end
    end
end

---Resize the current window width.
---@param delta integer Positive widens, negative narrows.
function M.resize_current_width(delta)
    -- Build a :vertical resize command using + or - based on the requested delta.
    vim.cmd(("vertical resize %s%d"):format(delta > 0 and "+" or "-", math.abs(delta)))
end

---Resize the current window height.
---@param delta integer Positive increases height, negative decreases height.
function M.resize_current_height(delta)
    -- Build a :resize command using + or - based on the requested delta.
    vim.cmd(("resize %s%d"):format(delta > 0 and "+" or "-", math.abs(delta)))
end

---Return the current visual selection without modifying the unnamed register.
---@return string
local function get_visual_selection()
    -- Save the unnamed register so this helper does not disturb normal editing.
    local old_reg = vim.fn.getreg('"')
    local old_regtype = vim.fn.getregtype('"')

    -- Yank the current visual selection into the unnamed register.
    vim.cmd('normal! "vy')
    local text = vim.fn.getreg('"')

    -- Restore the previous register contents and type.
    vim.fn.setreg('"', old_reg, old_regtype)
    return text
end

---Pick an Ex delimiter that does not occur in any provided string.
---@param ... string
---@return string
local function pick_delim(...)
    -- Try a small set of readable delimiters so generated commands need less
    -- escaping.
    local candidates = { "/", "#", "@", "|", ";", ":" }

    for _, d in ipairs(candidates) do
        local ok = true

        -- Reject a delimiter as soon as it appears in any argument.
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

    -- Fall back to / if every preferred delimiter appears in the inputs.
    return "/"
end

---Escape only the chosen Ex delimiter in a string.
---@param text string
---@param delim string
---@return string
local function escape_for_delim(text, delim)
    -- Escape just the active delimiter so the command stays readable.
    return text:gsub(vim.pesc(delim), "\\" .. delim)
end

---Convert plain text into a very nomagic Vim pattern.
---@param text string
---@param delim string
---@return string
local function vim_literal_pattern(text, delim)
    -- Escape backslashes first because Vim patterns treat them specially.
    text = text:gsub("\\", "\\\\")

    -- Escape the chosen command delimiter so the pattern remains syntactically
    -- valid inside :substitute or :vimgrep.
    text = escape_for_delim(text, delim)

    -- Prefix with \V so the text is matched literally instead of as a regex.
    return "\\V" .. text
end

---Escape text for the replacement side of :substitute.
---@param text string
---@param delim string
---@return string
local function escape_sub_replacement(text, delim)
    -- Escape backslashes because replacement strings interpret them specially.
    text = text:gsub("\\", "\\\\")

    -- Escape & so it is inserted literally instead of expanding to the match.
    text = text:gsub("&", "\\&")

    -- Escape the active delimiter so the replacement stays inside the command.
    text = escape_for_delim(text, delim)

    return text
end

---Return the active result list for the selected scope.
---@param quick boolean True for quickfix, false for location list.
---@return table
local function get_result_list(quick)
    -- Use the global quickfix list for multi-file mode, otherwise the current
    -- window's location list.
    return quick and vim.fn.getqflist() or vim.fn.getloclist(0)
end

---Clear the active result list.
---@param quick boolean True for quickfix, false for location list.
local function clear_result_list(quick)
    -- Replace the active list contents so stale matches are not reused later.
    if quick then
        vim.fn.setqflist({}, "r", { items = {} })
    else
        vim.fn.setloclist(0, {}, "r", { items = {} })
    end
end

---Return project files respecting .gitignore.
---
---Uses:
---  git ls-files --cached --others --exclude-standard
---
---This includes tracked files and untracked non-ignored files, while excluding
---ignored paths such as node_modules when they are listed in .gitignore.
---@return string[]
local function get_gitignored_file_list()
    local files = vim.fn.systemlist({
        "git",
        "ls-files",
        "--cached",
        "--others",
        "--exclude-standard",
    })

    if vim.v.shell_error ~= 0 then
        -- Fallback: ripgrep also respects .gitignore by default.
        -- --files lists files instead of matches.
        files = vim.fn.systemlist({
            "rg",
            "--files",
            "--hidden",
            "--glob",
            "!.git",
        })

        if vim.v.shell_error ~= 0 then
            vim.notify(
                "Cannot build project file list with git or rg",
                vim.log.levels.ERROR
            )
            return {}
        end
    end

    return vim.tbl_filter(function(file)
        return file ~= nil and file ~= ""
    end, files)
end

---Append vimgrep/lvimgrep results over a file list in chunks.
---@param quick boolean
---@param search_pattern string
---@param files string[]
---@return boolean
local function run_vimgrep_on_files(quick, search_pattern, files)
    clear_result_list(quick)

    local grep_cmd_first = quick and "vimgrep" or "lvimgrep"
    local grep_cmd_add = quick and "vimgrepadd" or "lvimgrepadd"

    local grep_pattern = escape_for_delim(search_pattern, "/")

    -- Keep chunks small enough to avoid excessive Ex command length.
    local chunk_size = 100
    local first = true

    for i = 1, #files, chunk_size do
        local chunk = {}

        for j = i, math.min(i + chunk_size - 1, #files) do
            table.insert(chunk, vim.fn.fnameescape(files[j]))
        end

        local cmd_name = first and grep_cmd_first or grep_cmd_add
        local cmd = string.format(
            "%s /%s/gj %s",
            cmd_name,
            grep_pattern,
            table.concat(chunk, " ")
        )

        local ok, err = pcall(vim.cmd, cmd)

        if not ok then
            local err_s = tostring(err)

            -- A chunk with no matches is fine. Keep scanning later chunks.
            if not err_s:match("E480: No match:") then
                clear_result_list(quick)

                if err_s:match("E54:") or err_s:match("E55:") then
                    vim.notify("Invalid Vim regex: " .. search_pattern, vim.log.levels.WARN)
                    return false
                end

                vim.notify("Search failed: " .. err_s, vim.log.levels.ERROR)
                return false
            end
        end

        first = false
    end

    local items = get_result_list(quick)
    if vim.tbl_isempty(items) then
        clear_result_list(quick)
        vim.notify(
            quick and "No matches found in project files" or "No matches found in current file",
            vim.log.levels.WARN
        )
        return false
    end

    return true
end

---Warn when any matched file is open and modified in memory.
---@param quick boolean True for quickfix, false for location list.
---@return boolean proceed True when the operation may continue.
local function warn_if_modified_matches(quick)
    -- Inspect the current search results and collect files that are open and
    -- modified but not yet written.
    local items = get_result_list(quick)
    local unsaved_files = {}
    local checked_files = {}

    for _, item in ipairs(items) do
        -- Prefer the explicit filename from the item, otherwise derive it from the
        -- buffer number when available.
        local filename = item.filename or vim.fn.bufname(item.bufnr or 0)

        -- Check each file only once even if multiple matches occur inside it.
        if filename ~= "" and not checked_files[filename] then
            local bufnr = vim.fn.bufnr(filename)

            if bufnr ~= -1 then
                -- Query the modified flag safely because option lookup may fail for
                -- some edge cases.
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

    -- Ask for confirmation before continuing when unsaved matching buffers exist.
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

---Run :vimgrep or :lvimgrep and populate the corresponding result list.
---@param quick boolean True for quickfix across project files, false for location list in current file.
---@param search_pattern string Vim regex pattern.
---@return boolean ok True when matches were found and the list is non-empty.
local function run_vimgrep_safe(quick, search_pattern)
    if quick then
        local files = get_gitignored_file_list()

        if vim.tbl_isempty(files) then
            clear_result_list(true)
            vim.notify("No project files found", vim.log.levels.WARN)
            return false
        end

        return run_vimgrep_on_files(true, search_pattern, files)
    end

    -- Current-file mode stays simple.
    local grep_pattern = escape_for_delim(search_pattern, "/")
    local cmd = string.format("lvimgrep /%s/gj %%", grep_pattern)

    local ok, err = pcall(vim.cmd, cmd)
    if not ok then
        local err_s = tostring(err)

        clear_result_list(false)

        if err_s:match("E480: No match:") then
            vim.notify("No matches found in current file", vim.log.levels.WARN)
            return false
        end

        if err_s:match("E54:") or err_s:match("E55:") then
            vim.notify("Invalid Vim regex: " .. search_pattern, vim.log.levels.WARN)
            return false
        end

        vim.notify("Search failed: " .. err_s, vim.log.levels.ERROR)
        return false
    end

    local items = get_result_list(false)
    if vim.tbl_isempty(items) then
        clear_result_list(false)
        vim.notify("No matches found in current file", vim.log.levels.WARN)
        return false
    end

    return true
end

---Search matches and prefill a bulk substitute command.
---@param quick boolean True for quickfix across files, false for location list in current file.
---@param search_pattern string Vim regex used by :vimgrep or :lvimgrep.
---@param replacement_seed string Initial replacement text.
---@param literal_mode boolean True to rebuild the substitute pattern literally.
local function search_and_prepare_replace(quick, search_pattern, replacement_seed, literal_mode)
    -- Reject empty input early to avoid generating misleading commands.
    if search_pattern == nil or search_pattern == "" then
        vim.notify("Empty search pattern", vim.log.levels.WARN)
        return
    end

    -- Populate the quickfix or location list with current matches.
    if not run_vimgrep_safe(quick, search_pattern) then
        return
    end

    local items = get_result_list(quick)

    -- Keep a second defensive guard in case the active list was emptied between
    -- steps.
    if vim.tbl_isempty(items) then
        clear_result_list(quick)
        vim.notify(
            quick and "No matches found in all files" or "No matches found in current file",
            vim.log.levels.WARN
        )
        return
    end

    -- Let the user stop before operating on files that also have unsaved changes.
    if not warn_if_modified_matches(quick) then
        return
    end

    -- Open the result window so matches are visible before the replace command is
    -- edited or executed.
    if quick then
        vim.cmd("copen")
    else
        vim.cmd("lopen")
    end

    -- Choose a readable delimiter for the generated substitute command.
    local delim = pick_delim(search_pattern, replacement_seed)

    -- Use literal matching for selection mode; otherwise preserve regex behavior.
    local sub_pattern
    if literal_mode then
        sub_pattern = vim_literal_pattern(replacement_seed, delim)
    else
        sub_pattern = escape_for_delim(search_pattern, delim)
    end

    -- Escape the initial replacement text for the replacement side of :substitute.
    local sub_replacement = escape_sub_replacement(replacement_seed, delim)

    -- Prefix with cfdo or lfdo depending on whether the operation spans all files
    -- or just the current one.
    local prefix = quick and ":cfdo " or ":lfdo "
    local close_cmd = quick and " | cclose" or " | lclose"

    -- Build a substitute command that:
    --   g  replaces all matches on each line
    --   I  forces case-sensitive matching
    --   e  suppresses errors if one file no longer matches during execution
    --   update writes only when the buffer changed
    local sub_cmd = string.format(
        "keeppatterns %%s%s%s%s%s%sgIe | update%s",
        delim,
        sub_pattern,
        delim,
        sub_replacement,
        delim,
        close_cmd
    )

    -- Prefill the command line instead of executing immediately so the user can
    -- inspect and edit it.
    vim.api.nvim_feedkeys(prefix .. sub_cmd, "n", false)

    -- Move the cursor back into the replacement field for convenient editing.
    local left = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
    local suffix_after_replacement = delim .. "gIe | update" .. close_cmd
    vim.api.nvim_feedkeys(left:rep(#suffix_after_replacement), "n", false)
end

---Prepare a replace command using the current visual selection as a literal pattern.
---@param quick boolean True for all files, false for current file.
function M.replace_selection(quick)
    -- Read the current visual selection without disturbing the unnamed register.
    local sel = get_visual_selection()
    if sel == "" then
        vim.notify("No selection found", vim.log.levels.WARN)
        return
    end

    -- Search literally for the selected text and seed the replacement with the
    -- same content.
    local search_pattern = vim_literal_pattern(sel, "/")
    search_and_prepare_replace(quick, search_pattern, sel, true)
end

---Prompt for a Vim regex and prepare a replace command from it.
---
---The prompt is initialized from the current search register.
---@param quick boolean True for all files, false for current file.
function M.replace_prompted_regex(quick)
    -- Start from the last search pattern so small refinements are quick.
    local last_search = vim.fn.getreg("/")
    local input = vim.fn.input("Regex: ", last_search)

    if input == nil or input == "" then
        vim.notify("Empty regex, aborted", vim.log.levels.WARN)
        return
    end

    -- Keep the search register aligned with what the user just entered so n/N and
    -- later search actions remain consistent.
    vim.fn.setreg("/", input)

    -- Use the entered regex as the search pattern and start with an empty
    -- replacement.
    search_and_prepare_replace(quick, input, "", false)
end

---Prepare a replace command from the current search register.
---@param quick boolean True for all files, false for current file.
function M.replace_last_search(quick)
    -- Reuse the current search register exactly as produced by / or ?.
    local pattern = vim.fn.getreg("/")

    if pattern == nil or pattern == "" then
        vim.notify("No previous search pattern", vim.log.levels.WARN)
        return
    end

    -- Build the replace workflow from the existing search pattern.
    search_and_prepare_replace(quick, pattern, "", false)
end

---Compatibility wrapper for the previous public API.
---@param quick boolean True for all files, false for current file.
---@param use_selection boolean True to use the visual selection, false to prompt for a regex.
function M.replace_word_under_cursor_or_selection(quick, use_selection)
    -- Preserve the old public entry point while delegating to the newer
    -- specialized functions.
    if use_selection then
        M.replace_selection(quick)
    else
        M.replace_prompted_regex(quick)
    end
end

return M
