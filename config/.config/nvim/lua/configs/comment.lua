return {
  -- toggle mappings in normal mode
  toggler = {
    line = "gcc", -- line-comment toggle
    block = "gbc", -- block-comment toggle
  },
  -- operator-pending mappings (works with motions)
  opleader = {
    line = "gc", -- line-comment operator
    block = "gb", -- block-comment operator
  },

  extra = {
    above = "gcO", -- add comment on line above
    below = "gco", -- add comment on line below
    eol = "gcA", -- add comment at end of line
  },
}
