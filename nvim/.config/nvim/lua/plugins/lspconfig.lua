return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        settings = {
          gopls = {
            buildFlags = { "-tags=e2e" },
            analyses = {
              unusedparams = true,
              staticcheck = true,
              packageComment = false,
              ST1000 = false,
              ST1003 = false,
            },
          },
        },
      },
    },
  },
}
