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
-- config.color_scheme = 'Catppuccin Frappe'
-- config.color_scheme = 'Catppuccin Latte'
-- config.color_scheme = 'Catppuccin Macchiato'
-- config.color_scheme = 'Catppuccin Mocha'

function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'rose-pine-moon'
  else
    return 'rose-pine-dawn'
  end
end
config.color_scheme = scheme_for_appearance(get_appearance())

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

-- Initial window size
config.initial_cols = 80
config.initial_rows = 24

config.window_padding = {
  left    = '20px',
  right   = '20px',
  top     = '20px',
  bottom  = '10px',
}

config.font_size = 13.0
config.font = wezterm.font('JetBrains Mono')
-- config.font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true })

-- and finally, return the configuration to wezterm
return config
