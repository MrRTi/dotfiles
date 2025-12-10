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
    return {
      set_environment_variables = {
        TERM_BG = "dark"
      },
      -- color_scheme = "carbonfox"
      color_scheme = 'Ayu Dark (Gogh)'
    }
  else
    return {
      set_environment_variables = {
        TERM_BG = "light"
      },
      -- color_scheme = "dayfox"
      color_scheme = 'Ayu Light (Gogh)'
    }
  end
end

for k, v in pairs(scheme_for_appearance(get_appearance())) do
  config[k] = v
end

local window_decorations = 'RESIZE'
local enable_tab_bar = false

config.enable_tab_bar = enable_tab_bar
config.window_decorations = window_decorations
config.use_fancy_tab_bar = false
config.window_padding = {
  left = "20px",
  right = "20px",
  top = "40px",
  bottom = "10px",
}

config.window_background_opacity = 1.0
config.text_background_opacity = 1.0

config.line_height = 1.1
config.font_size = 18
config.font = wezterm.font({
  family = "Fira Code",
  -- harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
  weight = "Medium",
})

config.keys = {
  -- Turn off the default CMD-m Hide action, allowing CMD-m to
  -- be potentially recognized and handled by the tab
  {
    key = 'h',
    mods = 'CMD|CTRL|ALT|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      if window_decorations == 'RESIZE' then
        window_decorations = 'TITLE | RESIZE'
        enable_tab_bar = true
      else
        window_decorations = 'RESIZE'
        enable_tab_bar = false
      end
      window:set_config_overrides({
        window_decorations = window_decorations,
        enable_tab_bar = enable_tab_bar
      })
    end),
  },
}

-- and finally, return the configuration to wezterm
return config
