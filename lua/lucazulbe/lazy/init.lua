local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "lucazulbe.lazy.always",    cond = true },
        { import = "lucazulbe.lazy.notvscode", cond = (function() return not vim.g.vscode end) },
	    { import = "lucazulbe.lazy.vscode",    cond = (function() return vim.g.vscode end) },
    },
    change_detection = { notify = false }
})
