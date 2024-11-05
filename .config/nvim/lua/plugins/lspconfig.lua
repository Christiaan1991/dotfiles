-- copy paste from
-- https://github.com/neovim/nvim-lspconfig/blob/ede4114e1fd41acb121c70a27e1b026ac68c42d6/lua/lspconfig/server_configurations/gopls.lua
local util = require("lspconfig.util")
local async = require("lspconfig.async")
-- -> the following line fixes it - mod_cache initially set to value that you've got from `go env GOMODCACHE` command, but it's hardset here
local mod_cache = "/root/go/pkg/mod"

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        -- here we solve the mod_cache issue by hard setting the mod_cache.
        -- It seems to be an issue with Zellij
        -- Issue: https://github.com/neovim/nvim-lspconfig/issues/2733
        root_dir = function(fname)
          -- see: https://github.com/neovim/nvim-lspconfig/issues/804
          if not mod_cache then
            local result = async.run_command("go env GOMODCACHE")
            if result and result[1] then
              mod_cache = vim.trim(result[1])
            end
          end
          if fname:sub(1, #mod_cache) == mod_cache then
            local clients = vim.lsp.get_active_clients({ name = "gopls" })
            if #clients > 0 then
              return clients[#clients].config.root_dir
            end
          end
          return util.root_pattern("go.work")(fname) or util.root_pattern("go.mod", ".git")(fname)
        end,
        single_file_support = true,

        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              fieldalignment = false,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
          },
        },
      },
    },
    inlay_hints = { enabled = false },
  },
}
