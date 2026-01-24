local alpha = require "alpha"
local dashboard = require "alpha.themes.dashboard"

vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#f38ba8" }) -- blue for tree
vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#a6adc8" }) -- gray for buttons
vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#f38ba8" }) -- pink for shortcuts
vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#f38ba8" }) -- pink for footer

dashboard.section.header.val = {
  "        ▁▁▁▔▔▕▗▖▁▁▁▁▁▁▁▁          ",
  "      ▁▁▁▁▁▁▁▁▁▏▁▔▘▁▁▁▁▖▁▁        ",
  "     ▕▕▖▘▝▗▃▁▐▚▇▇▁▃▛▜▍▏▕▉▏▏       ",
  "      ▕▁▁▝▐▏▄▐██▎▀▀▅▛▅█▏▁▏▖▁▁▏    ",
  "     ▕▁▔▕▕▝▜▀▂▞▔▔▂▂▔▔▗▂▆▀▔▁▗▏▏▁   ",
  "  ▕▁▁▁▕▏▁▂▂▏▕▀▘▆▃▇▉▘▝▇█▀▃▆▖▔▏▁▏▏  ",
  "  ▔▕▔▕▉▖▔▜█▏▙▅▅▏▁▅▅▕▟▍▅▏▔▏▁▁▁▏▔   ",
  "   ▁▁▁▔▔▔▕▏▜▀▗▆▁▆▜▕▋▖▔▔▁▁▁▁▔▔▏▏   ",
  "  ▕▕▔▔▂▁▁▔▔▔▕▔▔▔▔▕▀▋▔▃▏▘▔▕▔▔▏▏▏   ",
  "  ▕▕▕▔▔▘▘▁▖▔▔▔▕▂▏▕▔▔▔▔▔▁▁▕▕▏▏▏▏   ",
  "     ▕▏▏▔▝▘▏▁▁▏▔▔▔▔▕▁▏▔▔▔▔▔▔▏▔    ",
  "      ▔▔▕▁▔▔▔▔▔▔▔▏▔▔▔▔▔▔▔▔▔       ",
  "       ▕▔▔▔▔▔▔▏▁▁▁▁▖▏             ",
  "              ▕▕▗▆█▋▏             ",
  "             ▁▖▝███▋▏             ",
  "   ▁▁▁▁▁▁▏  ▕▕▘▁▝██▋▏             ",
  " ▁▁▂▖▗▃▗▖▏▏▔▔▕▕▂▟██▋              ",
  "▔▕▕▝▚▔▔▔▖▔▔▔▔▕▕▐▔██▋▏             ",
  "▕▕▕▔▝▔▔▔▗▂▁▁▔▕▕▟███▋▏             ",
  "         ▀▜▆▃▃▟████▋▏   ▁▁▁▁▁▕▁   ",
  "           ▔▀█▛█▎██▋▏  ▕▕▕▇▘▝▕▘▖▁ ",
  "              ▕▃▅██▋▏  ▔▔▕▝▀▎▀▘▏▔ ",
  "             ▕▕▜███▋▏ ▕▕▃▖▕▕▁▁▔▘▏▏",
  "             ▕▗▝████▅▅▇▛▀▔▔▔      ",
  "             ▕▝▗▞███▀▘▔           ",
  "             ▕▕▐▆██▋▏             ",
  "            ▕▁▁████▙▖▏            ",
  "           ▕▕▐▋▗████▙▎▏           ",
  "        ▁▁▁▕▃▛▘▐█████▆▃▃▁▁▁       ",
  "       ▕▏▝▗▛▀▋▝▔▜▀█▛▀▀▜▊▀▇▋▏      ",
}

dashboard.section.header.opts.hl = "AlphaHeader"

-- Buttons
dashboard.section.buttons.val = {
  dashboard.button("f", "", ":Telescope find_files<CR>"),
  dashboard.button("o", "", ":Telescope oldfiles<CR>"),
  dashboard.button("w", "󰈭", ":Telescope live_grep<CR>"),
  dashboard.button("s", "󱥚", ""), --[[ restore session ]]
  dashboard.button("'", "", ""), --[[ bookmarks ]]
}

-- Apply button highlights
for _, button in ipairs(dashboard.section.buttons.val) do
  button.opts.hl = "AlphaButtons"
  button.opts.hl_shortcut = "AlphaShortcut"
end

-- Footer
dashboard.section.footer.val = ""
dashboard.section.footer.opts.hl = "AlphaFooter"

-- Set footer highlight
vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#f38ba8" })
dashboard.section.footer.opts.hl = "Comment"

-- Layout
dashboard.config.layout = {
  { type = "padding", val = 4 },
  dashboard.section.header,
  { type = "padding", val = 2 },
  dashboard.section.buttons,
  { type = "padding", val = 2 },
  dashboard.section.footer,
}

alpha.setup(dashboard.config)

-- Footer (autocmd to update footer after lazy finishes loading)
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    local stats = require("lazy").stats()
    local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
    local line = string.rep("─", 40)

    dashboard.section.footer.val = {
      {
        type = "text",
        val = line,
        opts = { hl = "AlphaFooter", position = "center" },
      },
      {
        type = "text",
        val = "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. " ms",
        opts = { hl = "AlphaFooter", position = "center" },
      },
      {
        type = "text",
        val = line,
        opts = { hl = "AlphaFooter", position = "center" },
      },
    }

    -- Change footer type to group for nested elements
    dashboard.section.footer.type = "group"
    dashboard.section.footer.opts = { spacing = 0 }

    pcall(vim.cmd.AlphaRedraw)
  end,
})
