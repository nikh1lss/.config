-- read :h vim.lsp.config for changing options of lsp servers

local M = {}
local map = vim.keymap.set

-- export on_attach & capabilities
M.on_attach = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
  map("n", "<leader>ra", require "nvchad.lsp.renamer", opts "NvRenamer")
end

-- disable semanticTokens
M.on_init = function(client, _)
  if vim.fn.has "nvim-0.11" ~= 1 then
    if client.supports_method "textDocument/semanticTokens" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  else
    if client:supports_method "textDocument/semanticTokens" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end
end

local cmp_nvim_lsp = require "cmp_nvim_lsp"
M.capabilities = cmp_nvim_lsp.default_capabilities()

M.defaults = function()
  dofile(vim.g.base46_cache .. "lsp")
  require("nvchad.lsp").diagnostic_config()

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      M.on_attach(_, args.buf)
    end,
  })

  local lua_lsp_settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/luv/library",
        },
      },
    },
  }

  -- Use new vim.lsp.config API for Neovim 0.11+
  -- Global config for all servers
  vim.lsp.config("*", { capabilities = M.capabilities, on_init = M.on_init })

  -- Lua-specific settings
  vim.lsp.config("lua_ls", { settings = lua_lsp_settings })

  -- Enable all servers (except jdtls, this is handled by nvim-jdtls)
  vim.lsp.enable {
    "lua_ls",
    "clangd",
    "pyright",
    "ts_ls",
    "html",
    "cssls",
    "rust_analyzer",
    "jsonls",
  }
end

-- autocmd for jdtls setup
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function(args)
    require("jdtls.jdtls_setup").setup()
  end,
})

-- Disable cmp auto-trigger in lua files (lua_ls is annoyingly slow, specifically with newlines)
-- manually enable cmp in lua files with <C-Space>
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    require("cmp").setup.buffer {
      completion = {
        autocomplete = false,
      },
    }
  end,
})

return M
