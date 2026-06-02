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
      ruff = {
        init_options = {
          settings = {
            -- Pass the settings exactly as Ruff's linter natively expects them
            lint = {
              ignore = {
                "ASYNC101",
                "E501",
                "PLW0717",
                "PTH202",
                "D102",
                "ANN001",
                "ARG001",
                "PTH108",
                "ANN201",
                "ANN202",
                "ANN204",
                "E306",
                "ASYNC240",
                "ASYNC109",
              },
            },
          },
        },
      },
    },
  },
}
