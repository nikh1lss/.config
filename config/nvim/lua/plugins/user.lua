-- You can also add or configure plugins by creating files in this `plugins/` folder

---@type LazySpec
return {
  -- Enable default disabled plugins
  { "numToStr/Comment.nvim", enabled = true },
  { "JoosepAlviste/nvim-ts-context-commentstring", enabled = false },
  { "kevinhwang91/nvim-ufo", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },
}
