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

local mux = wezterm.mux

-- For example, changing the color scheme:
config.color_scheme = "Konsolas"

-- Change the font to Jetbrain Mono
config.font = wezterm.font("JetBrainsMono Nerd Font")

-- Change padding of the window
config.window_padding = {
	left = 2,
	right = 2,
	top = 0,
	bottom = 0,
}

-- Remove title bar
config.window_decorations = "NONE"

-- Background image
config.window_background_image = "/home/christiaan/wallpapers/trumpet-blurred-terminal-wallpapers.jpg"

-- Background settings
config.window_background_image_hsb = {
	-- Darken the background image by reducing it to 1/3rd
	brightness = 0.2,

	-- You can adjust the hue by scaling its value.
	-- a multiplier of 1.0 leaves the value unchanged.
	hue = 1.0,

	-- You can adjust the saturation also.
	saturation = 1.0,
}

-- Disable tab bar
config.enable_tab_bar = false

-- Run Zellij upon startup of Wezterm with the layout in the layout folder of zellij
config.default_prog = { "zellij" }

-- and finally, return the configuration to wezterm
return config
