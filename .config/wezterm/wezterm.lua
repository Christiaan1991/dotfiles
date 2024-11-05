--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/
-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- For example, changing the color scheme:
-- config.color_scheme = "Konsolas"

config.colors = {
	foreground = "#dcd7ba",
	background = "#111111",

	cursor_bg = "#c8c093",
	cursor_fg = "#c8c093",
	cursor_border = "#c8c093",

	selection_fg = "#c8c093",
	selection_bg = "#2d4f67",

	scrollbar_thumb = "#16161d",
	split = "#16161d",

	ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
	brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
	indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
}

-- Change the font to Jetbrain Mono
config.font = wezterm.font("JetBrains Mono SemiBold")
--
-- config.font = wezterm.font("Operator Mono SSm Lig Medium")
-- config.font_rules = {
-- 	-- For Bold-but-not-italic text, use this relatively bold font, and override
-- 	-- its color to a tomato-red color to make bold text really stand out.
-- 	{
-- 		intensity = "Bold",
-- 		italic = false,
-- 		font = wezterm.font_with_fallback(
-- 			"Operator Mono SSm Lig",
-- 			-- Override the color specified by the terminal output and force
-- 			-- it to be tomato-red.
-- 			-- The color value you set here can be any CSS color name or
-- 			-- RGB color string.
-- 			{ foreground = "tomato" }
-- 		),
-- 	},
--
-- 	-- Bold-and-italic
-- 	{
-- 		intensity = "Bold",
-- 		italic = true,
-- 		font = wezterm.font_with_fallback({
-- 			family = "Operator Mono SSm Lig",
-- 			italic = true,
-- 		}),
-- 	},
--
-- 	-- normal-intensity-and-italic
-- 	{
-- 		intensity = "Normal",
-- 		italic = true,
-- 		font = wezterm.font_with_fallback({
-- 			family = "Operator Mono SSm Lig",
-- 			weight = "DemiLight",
-- 			italic = true,
-- 		}),
-- 	},
--
-- 	-- half-intensity-and-italic (half-bright or dim); use a lighter weight font
-- 	{
-- 		intensity = "Half",
-- 		italic = true,
-- 		font = wezterm.font_with_fallback({
-- 			family = "Operator Mono SSm Lig",
-- 			weight = "Light",
-- 			italic = true,
-- 		}),
-- 	},
--
-- 	-- half-intensity-and-not-italic
-- 	{
-- 		intensity = "Half",
-- 		italic = false,
-- 		font = wezterm.font_with_fallback({
-- 			family = "Operator Mono SSm Lig",
-- 			weight = "Light",
-- 		}),
-- 	},
-- }

-- Change padding of the window
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Remove title bar
config.window_decorations = "NONE"

-- Background settings
config.window_background_opacity = 0.6

-- Disable tab bar
config.enable_tab_bar = false

-- Size of opening window
config.initial_cols = 800
config.initial_rows = 240

-- Size of font
config.font_size = 10

-- Run Zellij upon startup of Wezterm with the layout in the layout folder of zellij
config.default_prog = { "zellij" }

-- and finally, return the configuration to wezterm
return config
