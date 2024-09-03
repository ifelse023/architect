-- Pull in the wezterm API
local wezterm = require("wezterm")

return {
	font = wezterm.font("JetBrains Mono"),
	check_for_updates = false,
	color_scheme = "Catppuccin Mocha",
	front_end = "WebGpu",
	max_fps = 100,
	enable_wayland = true,
	animation_fps = 60,
	default_cursor_style = "SteadyBar",
	enable_scroll_bar = false,
	font_size = 14,
	hide_tab_bar_if_only_one_tab = true,
	scrollback_lines = 10000,
}
