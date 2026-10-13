-- re-applied on ColorScheme so theme reloads don't wipe them
local function telescope_hl()
  local hl = vim.api.nvim_set_hl
  -- hl(0, "TelescopeSelection", { bg = "#45475a", bold = true })
  hl(0, "TelescopeSelectionCaret", { fg = "#df6a8b" })
  hl(0, "TelescopePromptPrefix", { fg = "#df6a8b" })
  hl(0, "TelescopeResultsTitle", { fg = "#000000", bg = "#FFFFFF" })
  hl(0, "TelescopePromptTitle", { fg = "#000000", bg = "#FFFFFF" })
  hl(0, "TelescopePreviewTitle", { fg = "#000000", bg = "#FFFFFF" })
end
telescope_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = telescope_hl })

local no_titles = {
  results_title = false,
  -- prompt_title = false,
  preview_title = false,
}

return {
  defaults = {
    -- prompt_prefix = " λ ", --[[   ]]
    prompt_prefix = " > ", --[[   ]]
    selection_caret = " > ", --[[ >, ➮ ]]
    entry_prefix = "   ",
    sorting_strategy = "descending",
    layout_config = {
      horizontal = {
        prompt_position = "bottom",
        preview_width = 0.55,
      },
      width = 0.87,
      height = 0.80,
    },
    mappings = {
      n = {
        ["q"] = require("telescope.actions").close,
        ["o"] = function() end,
        ["O"] = function() end,
        ["<C-k>"] = require("telescope.actions").preview_scrolling_up,
        ["<C-j>"] = require("telescope.actions").preview_scrolling_down,
      },
    },
  },

  pickers = {
    find_files = vim.tbl_extend("force", no_titles, {
      hidden = true, -- show dotfiles
      find_command = { "fdfind", "--type", "f", "--hidden", "--no-ignore-vcs", "--strip-cwd-prefix" },
    }),
    live_grep = no_titles,
    oldfiles = no_titles,
    grep_string = no_titles,
    buffers = no_titles,
  },

  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
}
