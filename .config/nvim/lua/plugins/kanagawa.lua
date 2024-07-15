return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    opts = {
      transparent = true,
      background = {
        dark = "wave",
        light = "lotus",
      },
      overrides = function(colors)
        return {
          -- lazyGit selection row background defaults to palette.crystalBlue
          NormalFloat = { bg = "none", fg = "#a19a75" }, -- fg = e.g. terminal/lazygit primary text colours
          -- NormalFloat = { bg = "none", fg = "#9db0b0" },
          -- NormalFloat = { bg = "none", fg = colors.palette.katanaGray }, -- fg = e.g. terminal/lazygit text colours
          FloatBorder = { bg = "none", fg = colors.palette.winterYellow },
          FloatTitle = { bg = "none" },
          Pmenu = { bg = "none" }, -- bg = popup-menu background
          PmenuSel = { bg = "none", fg = colors.palette.samuraiRed },
          -- CmpCompletion = { bg = "none" },
          -- CmpCompletionSel = { bg = "none" },
          -- CmpCompletionThumb = { bg = "none" },
          -- CmpCompletionSbar = { bg = "none" },
          -- CmpCompletionBorder = { bg = "none", fg = "none" },

          -- lualine_x_6_normal = { fg = colors.palette.winterYellow },
          TelescopeTitle = { bg = "none" },
          TelescopeBorder = { bg = "none", fg = colors.palette.winterYellow },

          NeoTreeDirectoryName = { fg = "#8ba4b0" },
          NeoTreeDirectoryIcon = { fg = "#8ba4b0" },
          NeoTreeFloatBorder = { fg = colors.palette.winterYellow },
          NeoTreeFileName = { fg = colors.palette.fujiWhite },

          LazyGitBorder = { fg = "none", bg = "none" },
          -- CursorLine = { bg = "NONE", underline = true },
        }
      end,
      telescope = true,
      colors = {
        palette = {
          crystalBlue = "#393836", -- override crystalBlue for lazyGit UI improvement; crystalBlue is used as active line background
        },
        theme = {
          wave = {
            ui = {
              bg_dim = "#12120f",

              bg_m3 = "#0d0c0c",
              bg_m2 = "#12120f",
              bg_m1 = "#1D1C19",
              bg = "#181616",
              bg_p1 = "#282727",
              bg_p2 = "#393836",

              special = "#7a8382",
              whitespace = "#625e5a",
              nontext = "#625e5a",
            },
            syn = {
              fun = "#7E9CD8", -- I override crystalBlue for lazyGit UI improvement; fun defaults to crystalBlue; hard-code crystalBlue colour-code for compatibility
            },
          },
          dragon = {
            ui = {
              fg = "#DCD7BA", -- replace with wave theme colour
              fg_dim = "#C8C093", -- replace with wave theme colour
            },
          },
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
    },
  },
}
