-- --------------------------------------------------------------------------------------------------------------------
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

config.window_decorations = "RESIZE"

config.window_padding = {
  left = "30px",
  right = "30px",
  top = "35px",
  bottom = "15px",
}

config.window_background_opacity = 0.85
config.text_background_opacity = 1.0

config.line_height = 1.1
config.font_size = 17
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
      else
        window_decorations = 'RESIZE'
      end
      window:set_config_overrides({
        window_decorations = window_decorations,
      })
    end),
  },
}

-- and finally, return the configuration to wezterm
return config
