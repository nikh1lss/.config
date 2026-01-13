dofile(vim.g.base46_cache .. "telescope")

return {
  defaults = {
    prompt_prefix = "   ",
    selection_caret = " ",
    entry_prefix = " ",
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
