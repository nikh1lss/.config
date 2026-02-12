-- Pull in the wezterm API
local wezterm = require "wezterm"

-- This will hold the configuration.
local config = wezterm.config_builder()
-- gpu
-- local gpus = wezterm.gui.enumerate_gpus()
-- config.webgpu_preferred_adapter = gpus[6]
config.webgpu_preferred_adapter = {
  backend = "GL",
  device = 0,
  device_type = "Other",
  name = "AMD Radeon RX 7800 XT",
  vendor = 0,
}
config.front_end = "WebGpu"
-- config.front_end = "OpenGL"
config.max_fps = 250
config.animation_fps = 180
config.term = "xterm-256color"
-- Set WSL2 as the default shell
config.default_domain = "WSL:Ubuntu-22.04"
-- changing the initial geometry for new windows
config.initial_cols = 150
config.initial_rows = 28
config.window_decorations = "NONE"
-- or, changing the font size and color scheme.
config.font_size = 13.5
config.cell_width = 0.9
-- config.color_scheme = "Cloud (terminal.sexy)"
config.adjust_window_size_when_changing_font_size = false
-- config.window_padding = {
--   left = 0,
--   right = 0,
--   top = 0,
--   bottom = 0,
-- }
-- tabs
-- config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true
config.font = wezterm.font "Iosevka Nerd Font"
-- Disable bell :)
config.audible_bell = "Disabled"
config.background = {
  {
    source = { File = "C:/Users/nsing/OneDrive/Pictures/spider.png" },
    opacity = 1.0,
    hsb = { brightness = 0.4 },
  },
}
-- Cursor
config.colors = {
  cursor_bg = "#FFFFFF",
  cursor_fg = "#000000",
  cursor_border = "#FFFFFF",
}
config.window_background_opacity = 1.0
config.enable_tab_bar = true

-- TODO configure sessions/workspaces + splitting
-- not as responsive as native terminal.. gg

-- Finally, return the configuration to wezterm:
return config
