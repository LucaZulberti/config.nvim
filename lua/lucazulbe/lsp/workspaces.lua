local M = {}

M.get_folders_from_file = function(root_dir, filename)
    local uv = vim.uv
    filename = filename or ".workspace-folders"
    local path = root_dir .. "/" .. filename

    local fd = uv.fs_open(path, "r", tonumber("066", 8))
    if not fd then
        vim.notify("Workspace file not found: " .. path, vim.log.levels.WARN)
        return
    end

    local stat = uv.fs_fstat(fd)
    local content = uv.fs_read(fd, stat.size, 0)
    uv.fs_close(fd)

    local folders = {}

    for line in content:gmatch("[^\r\n]+") do
        local folder = vim.fn.fnamemodify(root_dir .. "/" .. line, ":p")
        table.insert(folders, folder)
    end

    return folders
end

M.add_folders_from_file = function(root_dir, filename)
    local folders = M.get_folders_from_file(root_dir, filename)
    for _, folder in ipairs(folders) do
        vim.lsp.buf.add_workspace_folder(folder)
        vim.notify("Added workspace folder: " .. folder, vim.log.levels.INFO)
    end
end

return M
