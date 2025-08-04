return {
  "mrcjkb/rustaceanvim",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  version = '^6', -- Recommended
  lazy = false, -- This plugin is already lazy
  init = function()
    local lz_lsp = require("lucazulbe.lsp")

    vim.g.rustaceanvim = {
      server = {
        capabilities = lz_lsp.config.capabilities,
        on_attach = lz_lsp.config.on_attach,
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            checkOnSave = true,
            files = {
              watcher = "server",
            },
            hover = {
              -- Show inferred types, including those for variables and expressions
              showClosureReturnType = true,
              showUnimplemented = true,
              docs = {
                enable = true,
              },
            },
            assist = {
              -- Enable type hints in inlay hints
              importMergeBehavior = "last",
              importPrefix = "by_self",
            },
            inlayHints = {
              -- Enable inlay hints (type hints, parameter hints, etc.)
              enable = true,
              typeHints = true,
              parameterHints = true,
              chainingHints = true,
            },
          },
        },
      },
    }
  end,
}
