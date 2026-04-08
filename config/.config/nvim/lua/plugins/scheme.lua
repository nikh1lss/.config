local scheme = "gruber-darker"

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    enabled = scheme == "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "auto",
        dark_variant = "main",
        dim_inactive_windows = false,
        extend_background_behind_borders = true,
        styles = {
          bold = true,
          italic = false,
          transparency = true,
        },
        highlight_groups = {
          Comment = { italic = true },
          ["@comment"] = { italic = true },
          CmpBorder = { fg = "muted", bg = "none" },
          CmpPmenu = { bg = "none" },
        },
      })
      vim.cmd("colorscheme rose-pine")
    end,
  },

  {
    "ellisonleao/gruvbox.nvim",
    enabled = scheme == "gruvbox",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
        overrides = {
          CursorLineNr = { fg = "#fabd2f", bg = "", bold = true },
          LineNr = { bg = "" },
        },
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    enabled = scheme == "kanagawa",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true,
        dimInactive = false,
        terminalColors = true,
        theme = "dragon",
        background = {
          dark = "wave",
          light = "lotus",
        },
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            CmpBorder = { fg = theme.ui.shade0, bg = "none" },
            CmpPmenu = { bg = "none" },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            TelescopeBorder = { bg = "none" },
            TelescopePromptBorder = { bg = "none" },
            TelescopeResultsBorder = { bg = "none" },
            TelescopePreviewBorder = { bg = "none" },
          }
        end,
      })
      vim.cmd("colorscheme kanagawa")
    end,
  },

  {
    "blazkowolf/gruber-darker.nvim",
    enabled = scheme == "gruber-darker",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruber-darker").setup({
        bold = true,
        invert = {
          signs = false,
          tabline = false,
          visual = false,
        },
        italic = {
          strings = false,
          comments = true,
          operators = false,
          folds = true,
        },
        undercurl = true,
        underline = true,
      })
      vim.cmd.colorscheme("gruber-darker")

      local hl = vim.api.nvim_set_hl
      -- hl(0, "Cursor", { fg = "#000000", bg = "#ffffff" })
      hl(0, "MatchParen", { fg = "#ffffff", bg = "#52494e", bold = true })
      -- hl(0, "MatchParen", { fg = "#ffffff", bg = "#7a7a7a", bold = true })
      hl(0, "Normal", { bg = "none" })
      hl(0, "NormalNC", { bg = "none" })
      hl(0, "NormalFloat", { bg = "none" })
      hl(0, "FloatBorder", { bg = "none" })
      hl(0, "FloatTitle", { bg = "none" })
      hl(0, "SignColumn", { bg = "none" })
      hl(0, "LineNr", { bg = "none" })

      hl(0, "CmpBorder", { fg = "#52494e", bg = "none" })
      hl(0, "CmpPmenu", { bg = "none" })

      hl(0, "LazyNormal", { bg = "#181818" })
      hl(0, "MasonNormal", { bg = "#181818" })

      hl(0, "IblIndent", { fg = "#282828" })
      hl(0, "IblScope", { fg = "#52494e" })

      hl(0, "TelescopeBorder", { bg = "none" })
      hl(0, "TelescopePromptBorder", { bg = "none" })
      hl(0, "TelescopeResultsBorder", { bg = "none" })
      hl(0, "TelescopePreviewBorder", { bg = "none" })
    end,
  },
}
