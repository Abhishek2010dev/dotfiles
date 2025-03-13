local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "tokyonight"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 19
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.75
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"

return config
