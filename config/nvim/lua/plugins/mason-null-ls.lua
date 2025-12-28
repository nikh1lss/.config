---@type LazySpec
return {
  "jay-babu/mason-null-ls.nvim",
  opts = {
    handlers = {
      checkstyle = function() end, -- disable auto-setup, we configure it manually in none-ls.lua
    },
  },
}
