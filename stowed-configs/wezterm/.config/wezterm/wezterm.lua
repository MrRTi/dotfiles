-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'rose-pine-dawn'
-- config.color_scheme = 'rose-pine-moon'

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

config.window_padding = {
  left = '1cell',
  right = '1cell',
  top = '0.5cell',
  bottom = '0.5cell',
}

config.font_size = 16.0
config.font = wezterm.font('JetBrains Mono')
-- config.font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true })

-- and finally, return the configuration to wezterm
return config
