local bufnr = vim.api.nvim_get_current_buf()

-- Show code actions from rust-analyzer
vim.keymap.set(
  "n",
  "<leader>ca",
  function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  { silent = true, buffer = bufnr }
)

-- Enable inlay hints
vim.lsp.inlay_hint.enable(true)
