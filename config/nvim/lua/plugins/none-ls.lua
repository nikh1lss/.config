-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    -- opts variable is the default configuration table for the setup function call
    -- local null_ls = require "null-ls"
    local null_ls = require "null-ls"

    -- Remove any existing checkstyle source
    opts.sources = vim.tbl_filter(function(source) return source.name ~= "checkstyle" end, opts.sources or {})

    -- Add checkstyle with proper config
    table.insert(
      opts.sources,
      null_ls.builtins.diagnostics.checkstyle.with {
        extra_args = { "-c", vim.fn.expand "~/dotfiles/config/checkstyle/checkstyle.xml" },
      }
    )

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  end,
}
