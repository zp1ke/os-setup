-- WezTerm Configuration
-- Shared template across Kubuntu/macOS/NixOS

local wezterm = require 'wezterm'
local config = {}

-- Use config builder if available (WezTerm 20220807-113146-c2fee766 and later)
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ===================================
-- FONT CONFIGURATION
-- ===================================
config.font = wezterm.font('FiraCode Nerd Font')
config.font_size = 14.0

-- ===================================
-- APPEARANCE
-- ===================================
function scheme_for_appearance(appearance)
  if appearance:find('Dark') then
    return 'Tokyo Night'
  else
    return 'Catppuccin Latte'
  end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

-- ===================================
-- WINDOW CONFIGURATION
-- ===================================
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9

config.initial_cols = 120
config.initial_rows = 30

config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

-- ===================================
-- TAB BAR
-- ===================================
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false

-- ===================================
-- SCROLLBACK
-- ===================================
config.scrollback_lines = 10000
config.enable_scroll_bar = true

-- Fix scrollback when SSH'd to remote servers
config.enable_kitty_keyboard = false

-- Ensure mouse wheel scrolls the scrollback buffer
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'NONE',
    action = wezterm.action.ScrollByLine(-3),
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'NONE',
    action = wezterm.action.ScrollByLine(3),
  },
}

-- ===================================
-- SHELL CONFIGURATION
-- ===================================
-- WezTerm will use your default shell.

-- ===================================
-- SYSTEM SPECIFIC
-- ===================================

-- macOS performance
config.max_fps = 120
config.animation_fps = 60

-- macOS cursor
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 800

-- macOS bell
config.audible_bell = "Disabled"

-- macOS Option key behavior
config.keys = {}
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- macOS: ensure theme updates on reload
wezterm.on('window-config-reloaded', function(window, pane)
  local appearance = window:get_appearance()
  local overrides = window:get_config_overrides() or {}

  overrides.color_scheme = scheme_for_appearance(appearance)
  window:set_config_overrides(overrides)
end)

return config
