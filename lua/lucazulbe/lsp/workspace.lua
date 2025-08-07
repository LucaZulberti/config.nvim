local M = {}

M.get_folders_from_file = function(root_dir, filename)
    local uv = vim.uv
    local folders = {}

    filename = filename or ".workspace-folders"

    if not root_dir then return folders end

    local path = root_dir .. "/" .. filename

    local fd = uv.fs_open(path, "r", tonumber("066", 8))
    if not fd then
        return folders
    end

    local stat = uv.fs_fstat(fd)
    local content = uv.fs_read(fd, stat.size, 0)
    uv.fs_close(fd)

    for line in content:gmatch("[^\r\n]+") do
        local folder = vim.fn.fnamemodify(root_dir .. "/" .. line, ":p")
        table.insert(folders, folder)
    end

    return folders
end

M.add_folders_from_file = function(root_dir, filename)
    local folders = M.get_folders_from_file(root_dir, filename)

    if not folders or vim.tbl_isempty(folders) then
        return
    end

    for _, folder in ipairs(folders) do
        vim.lsp.buf.add_workspace_folder(folder)
    end
    vim.notify("Loaded workspace folders from " .. root_dir .. "/" .. filename, vim.log.levels.INFO)
end

return M
