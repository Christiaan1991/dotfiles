return {
  -- Language Server Protocol for Terraform/OpenTofu
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Terraform LSP with OpenTofu support
        terraformls = {
          filetypes = { "terraform", "terraform-vars", "hcl" },
          settings = {
            terraform = {
              -- Enable validation and formatting
              validation = {
                enable = true,
              },
              formatting = {
                enable = true,
              },
            },
          },
        },
      },
    },
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "terraform", "hcl" })
      end
    end,
  },

  -- Mason for automatic LSP installation
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "terraform-ls", -- Terraform Language Server
        "tflint", -- Terraform linter
        "tfsec", -- Terraform security scanner
      })
    end,
  },

  -- Conform for formatting with terraform fmt
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
      },
      formatters = {
        terraform_fmt = {
          command = "tofu", -- Use OpenTofu binary instead of terraform
          args = { "fmt", "-" },
          stdin = true,
        },
      },
    },
  },

  -- Additional linting with nvim-lint
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        terraform = { "tflint", "tfsec" },
        ["terraform-vars"] = { "tflint" },
      },
      linters = {
        tflint = {
          -- Override to use OpenTofu-compatible configuration
          cmd = "tflint",
          args = { "--format=json", "--force" },
        },
      },
    },
  },

  -- File type detection for Terraform files
  {
    "hashivim/vim-terraform",
    ft = { "terraform", "hcl" },
    config = function()
      -- Enable auto-formatting on save
      vim.g.terraform_fmt_on_save = 1
      -- Use OpenTofu binary for commands
      vim.g.terraform_binary_path = "tofu"
      -- Enable folding
      vim.g.terraform_fold_sections = 1
      -- Align settings
      vim.g.terraform_align = 1
    end,
  },
}
