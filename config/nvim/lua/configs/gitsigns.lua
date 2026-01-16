dofile(vim.g.base46_cache .. "git")

return {
  signs = {
    delete = { text = "󰍵" },
    changedelete = { text = "󱕖" },
  },
  current_line_blame = false, -- off by default, toggle with <leader>gb
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 0,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
}
-- toggle git full file blame with <leader>gB
