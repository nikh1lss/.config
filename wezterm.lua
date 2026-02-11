-- Optional: you can also launch WSL explicitly via default_prog
-- config.default_prog = { 'wsl.exe', '--distribution', 'Ubuntu', '--cd', '~' }

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Set WSL2 as the default shell
config.default_domain = "WSL:Ubuntu-22.04"

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 13.5
config.color_scheme = "AdventureTime"

config.font = wezterm.font("Iosevka Nerd Font")

-- Disable bell
config.audible_bell = "Disabled"

-- Cursor
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0
config.colors = {
	cursor_bg = "#FFFFFF",
	cursor_fg = "#000000",
}

config.window_background_opacity = 1.0

config.enable_tab_bar = false

-- Finally, return the configuration to wezterm:
return config
