local wezterm = require("wezterm")

local function font_with_fallback(name, params)
	local names = { name, "Material Symbols Outlined" }
	return wezterm.font_with_fallback(names, params)
end

local font_name = "JetBrainsMono Nerd Font"
return {

	font_size = 16,

	window_padding = {
		left = 10,
		right = 0,
		top = 2,
		bottom = 0,
	},

	-- Font config
	font = font_with_fallback(font_name),
	font_rules = {
		{
			italic = true,
			font = font_with_fallback(font_name, { italic = true }),
		},
		{
			italic = false,
			font = font_with_fallback(font_name, { bold = true }),
		},
		{
			intensity = "Bold",
			font = font_with_fallback(font_name, { bold = true }),
		},
	},

	color_scheme = "Tokyo Night",
	warn_about_missing_glyphs = false,
	enable_scroll_bar = false,
	enable_tab_bar = false,
	scrollback_lines = 8000,
	front_end = "WebGpu",
	use_fancy_tab_bar = false,
	enable_wayland = true,
	default_cursor_style = "SteadyBar",
	automatically_reload_config = true,
	check_for_updates = false,

	disable_default_key_bindings = true,
	keys = {
		{
			key = "q",
			mods = "CTRL",
			action = wezterm.action({ CloseCurrentPane = { confirm = false } }),
		},
		{
			key = "v",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ PasteFrom = "Clipboard" }),
		},
		{
			key = "c",
			mods = "CTRL|SHIFT",
			action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }),
		},
		{ key = "=", mods = "CTRL", action = "IncreaseFontSize" },
		{ key = "-", mods = "CTRL", action = "DecreaseFontSize" },
		{ key = "0", mods = "CTRL", action = "ResetFontSize" },
		{ key = "Z", mods = "CTRL", action = "TogglePaneZoomState" },
	},
}
