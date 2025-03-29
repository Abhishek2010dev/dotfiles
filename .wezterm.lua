local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "tokyonight"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 18
config.enable_tab_bar = false
-- config.window_decorations = "RESIZE"
config.window_background_opacity = 0.75
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"

-- Remove padding
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

return config
