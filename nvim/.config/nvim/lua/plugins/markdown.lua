return {
  {
    -- Install markdown preview, use npx if available.
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function(plugin)
      if vim.fn.executable("npx") then
        vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
      else
        vim.cmd([[Lazy load markdown-preview.nvim]])
        vim.fn["mkdp#util#install"]()
      end
    end,
    init = function()
      if vim.fn.executable("npx") then
        vim.g.mkdp_filetypes = { "markdown" }
      end
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      checkbox = {
        enabled = true,
        unchecked = {
          icon = "   󰄱 ",
          highlight = "RenderMarkdownUnchecked",
          scope_highlight = nil,
        },
        checked = {
          icon = "   󰱒 ",
          highlight = "RenderMarkdownChecked",
          scope_highlight = "Comment",
        },
        custom = {
          todo = { raw = "[-]", rendered = "   󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
          -- inprogress = { raw = "[~]", rendered = "   󰡖 ", highlight = "RenderMarkdownChecked", scope_highlight = nil },
          -- inprogress = { raw = "[~]", rendered = "   󱑣 ", highlight = "RenderMarkdownChecked", scope_highlight = nil },
          inprogress = {
            raw = "[~]",
            rendered = "   󱗝 ",
            highlight = "RenderMarkdownChecked",
            scope_highlight = nil,
          },
          -- inprogress = { raw = "[~]", rendered = "   󰄗 ", highlight = "RenderMarkdownChecked", scope_highlight = nil },
          -- inprogress = { raw = "[~]", rendered = "   󱅶 ", highlight = "RenderMarkdownChecked", scope_highlight = nil },
          canceled = {
            raw = "[/]",
            rendered = "   󱋭 ",
            highlight = "Comment",
            scope_highlight = "Comment",
          },
        },
      },
      heading = {
        enabled = true,
        sign = false,
        position = "overlay",
        icons = { "󰲡  ", "󰲣  ", "󰲥  ", "󰲧  ", "󰲩  ", "󰲫  " },
        signs = { "󰫎 " },
        width = "block",
        left_pad = 0,
        right_pad = 2,
        min_width = 5,
        border = false,
        border_prefix = false,
        above = "▄",
        below = "▀",
        backgrounds = {
          -- "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          -- "RenderMarkdownH3Bg",
          -- "RenderMarkdownH4Bg",
          -- "RenderMarkdownH5Bg",
          -- "RenderMarkdownH6Bg",
        },
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },
      code = {
        border = "thin",
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", "/home/wolf/.markdownlint.jsonc" },
        },
      },
    },
  },
}
