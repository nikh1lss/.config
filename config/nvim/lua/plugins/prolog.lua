-- need swi-prolog installed, then with swipl, pack_install(prolog_lsp).

return {
  {
    "AstroNvim/astrolsp",
    opts = {
      config = {
        prolog_lsp = {
          -- You need SWI-Prolog installed
          cmd = {
            "swipl",
            "-g",
            "use_module(library(lsp_server)).",
            "-g",
            "lsp_server:main",
            "-t",
            "halt",
            "--",
            "stdio",
          },
          filetypes = { "prolog" },
          root_dir = require("lspconfig.util").root_pattern(".git", "pack.pl"),
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "prolog" }, -- Add Prolog syntax highlighting
    },
  },
}
