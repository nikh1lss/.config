pcall(function()
  dofile(vim.g.base46_cache .. "syntax")
  dofile(vim.g.base46_cache .. "treesitter")
end)

return {
  ensure_installed = {
    "lua",
    "luadoc",
    "printf",
    "vim",
    "vimdoc",
    "python",
    "javascript",
    "typescript",
    "tsx",
    "java",
    "c",
    "cpp",
    "rust",
    "c_sharp",
    "json",
    "javadoc",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>", -- start selecting current node
      node_incremental = "<C-space>", -- expand to parent node
      scope_incremental = false, -- disabled (would expand to scope)
      node_decremental = "<bs>", -- shrink selection back
    },
  },
}
