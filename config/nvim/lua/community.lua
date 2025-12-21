-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.cpp" }, -- includes c pack
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.pack.golangci-lint" }, -- includes go pack
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.spring-boot" },
  { import = "astrocommunity.pack.zig" },
  { import = "astrocommunity.pack.haskell" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.xml" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.pack.docker" },

  -- experimental support with zsh
  { import = "astrocommunity.pack.bash" },

  -- import/override with your plugins folder
}
