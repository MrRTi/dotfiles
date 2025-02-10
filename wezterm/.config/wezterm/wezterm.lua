-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Tokyo Night Moon"
	else
		return "Tokyo Night Day"
	end
end

config.color_scheme = scheme_for_appearance(get_appearance())

config.enable_tab_bar = false

config.window_padding = {
	left = "20px",
	right = "20px",
	top = "20px",
	bottom = "10px",
}

config.window_background_opacity = 0.9

config.font_size = 15.0
config.font = wezterm.font({
	family = "JetBrains Mono",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	weight = "DemiBold",
})
-- config.font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true })

-- and finally, return the configuration to wezterm
return config
