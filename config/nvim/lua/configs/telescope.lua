dofile(vim.g.base46_cache .. "telescope")

vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#df6a8b" })
vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = "#000000", bg = "#FFFFFF" })
vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = "#000000", bg = "#FFFFFF" })
vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = "#000000", bg = "#FFFFFF" })

return {
  defaults = {
    prompt_prefix = " λ ", --[[  ]]
    selection_caret = " > ",
    entry_prefix = "   ",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "bottom",
        preview_width = 0.55,
      },
      width = 0.87,
      height = 0.80,
    },
    mappings = {
      n = { ["q"] = require("telescope.actions").close },
    },
  },

  pickers = {
    find_files = {
      -- hidden = true, -- show dotfiles
      no_ignore = true, -- show gitignore files
    },
  },

  extensions_list = { "themes", "terms" },
  extensions = {},
}
