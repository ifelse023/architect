-- Pull in the wezterm API
local wezterm = require("wezterm")

return {
	font = wezterm.font("JetBrains Mono"),
	check_for_updates = false,
	color_scheme = "Catppuccin Mocha",
	front_end = "WebGpu",
	max_fps = 120,
	enable_wayland = true,
	animation_fps = 60,
	default_cursor_style = "SteadyBar",
	enable_scroll_bar = false,
	font_size = 13,
	hide_tab_bar_if_only_one_tab = true,
	scrollback_lines = 10000,

	keys = {
		{
			key = "v",
			mods = "CTRL",
			action = wezterm.action({
				SplitHorizontal = { domain = "CurrentPaneDomain" },
			}),
		},
		{
			key = "s",
			mods = "CTRL",
			action = wezterm.action({
				SplitVertical = { domain = "CurrentPaneDomain" },
			}),
		},
		{
			key = "q",
			mods = "CTRL",
			action = wezterm.action({ CloseCurrentPane = { confirm = false } }),
		},
		{
			key = "h",
			mods = "CTRL|ALT",
			action = wezterm.action({ ActivatePaneDirection = "Left" }),
		},
		{
			key = "l",
			mods = "CTRL|ALT",
			action = wezterm.action({ ActivatePaneDirection = "Right" }),
		},
		{
			key = "k",
			mods = "CTRL|ALT",
			action = wezterm.action({ ActivatePaneDirection = "Up" }),
		},
		{
			key = "j",
			mods = "CTRL|ALT",
			action = wezterm.action({ ActivatePaneDirection = "Down" }),
		},
		{
			key = "Tab",
			mods = "CTRL",
			action = wezterm.action({ ActivateTabRelative = 1 }),
		},
		{
			key = "Tab",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ ActivateTabRelative = -1 }),
		},
	},
}
