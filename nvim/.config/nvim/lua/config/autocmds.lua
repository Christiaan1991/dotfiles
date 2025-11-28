-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Terraform/OpenTofu specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "terraform", "hcl" },
  callback = function()
    -- Set specific options for Terraform files
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
    vim.opt_local.commentstring = "# %s"

    -- Enable spell check for comments
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"

    -- Set up folding for Terraform blocks
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt_local.foldenable = false -- Start with folds open
  end,
})

-- Auto-format Terraform files on save with OpenTofu
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.tf", "*.tfvars", "*.hcl" },
  callback = function()
    if vim.fn.executable("tofu") == 1 then
      vim.cmd("silent !tofu fmt " .. vim.fn.expand("%"))
      vim.cmd("edit") -- Reload the file to see the formatting changes
    end
  end,
})
