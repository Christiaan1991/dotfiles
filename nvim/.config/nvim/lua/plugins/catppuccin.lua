return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    flavour = "latte", -- latte, frappe, macchiato, mocha
    background = { -- :h background
      light = "latte",
      dark = "mocha",
    },
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
      enabled = false, -- dims the background color of inactive window
      shade = "dark",
      percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
      comments = { "italic" }, -- Change the style of comments
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = { "bold" },
      strings = {},
      variables = {},
      numbers = {},
      booleans = { "bold" },
      properties = {},
      types = {},
      operators = {},
      -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = function(C)
      return {
        CmpItemKindSnippet = { fg = C.base, bg = C.mauve },
        CmpItemKindKeyword = { fg = C.base, bg = C.red },
        CmpItemKindText = { fg = C.base, bg = C.teal },
        CmpItemKindMethod = { fg = C.base, bg = C.blue },
        CmpItemKindConstructor = { fg = C.base, bg = C.blue },
        CmpItemKindFunction = { fg = C.base, bg = C.blue },
        CmpItemKindFolder = { fg = C.base, bg = C.blue },
        CmpItemKindModule = { fg = C.base, bg = C.blue },
        CmpItemKindConstant = { fg = C.base, bg = C.peach },
        CmpItemKindField = { fg = C.base, bg = C.green },
        CmpItemKindProperty = { fg = C.base, bg = C.green },
        CmpItemKindEnum = { fg = C.base, bg = C.green },
        CmpItemKindUnit = { fg = C.base, bg = C.green },
        CmpItemKindClass = { fg = C.base, bg = C.yellow },
        CmpItemKindVariable = { fg = C.base, bg = C.flamingo },
        CmpItemKindFile = { fg = C.base, bg = C.blue },
        CmpItemKindInterface = { fg = C.base, bg = C.yellow },
        CmpItemKindColor = { fg = C.base, bg = C.red },
        CmpItemKindReference = { fg = C.base, bg = C.red },
        CmpItemKindEnumMember = { fg = C.base, bg = C.red },
        CmpItemKindStruct = { fg = C.base, bg = C.blue },
        CmpItemKindValue = { fg = C.base, bg = C.peach },
        CmpItemKindEvent = { fg = C.base, bg = C.blue },
        CmpItemKindOperator = { fg = C.base, bg = C.blue },
        CmpItemKindTypeParameter = { fg = C.base, bg = C.blue },
        CmpItemKindCopilot = { fg = C.base, bg = C.teal },
      }
    end,
    default_integrations = true,
    opts = {
      transparent_background = true,
      integrations = {
        aerial = true,
        alpha = true,
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        headlines = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
      custom_highlights = function(colors)
        return {
          Normal = { bg = "NONE" },
          NormalNC = { bg = "NONE" },
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },
          Pmenu = { bg = "NONE" },
          PmenuSel = { bg = colors.surface0 },
          TelescopeNormal = { bg = "NONE" },
          TelescopeBorder = { bg = "NONE" },

          -- -- Starting screen customization
          -- SnacksDashBoardTitle = { fg = "#27b427" },
          -- SnacksDashBoardHeader = { fg = "#27b427" },
          -- SnacksDashBoardFooter = { fg = "#27b427" },
          -- SnacksDashBoardDesc = { fg = "#1b671b" },
          -- SnacksDashBoardFile = { fg = "#1b671b" },
          -- SnacksDashBoardIcon = { fg = "#1b671b" },
          -- SnacksDashBoardSpecial = { fg = "#1b671b" },
        }
      end,
    },
  },
}
