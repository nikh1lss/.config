local options = {
  autostart = true,
  autoload = false,
  on_autoload_no_session = function()
    vim.notify("No existing session to load.")
  end,
  follow_cwd = true,
  use_git_branch = true,
  should_save = function()
    local dominated = { "", "alpha", "NvimTree", "lazy" }
    return not vim.tbl_contains(dominated, vim.bo.filetype)
  end,
  telescope = {
    mappings = {
      copy_session = "<C-c>",
      change_branch = "<C-b>",
      delete_session = "<C-d>",
    },
  },
}

return options
