-- WezTerm Configuration for macOS
-- Based on NixOS setup

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
-- Automatic theme switching based on macOS system appearance
-- Set initial theme (will be overridden by appearance detection)
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
-- Window decorations
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9

-- Initial Size
config.initial_cols = 120
config.initial_rows = 30

-- Padding
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
config.scrollback_lines = 3500
config.enable_scroll_bar = true

-- ===================================
-- SHELL CONFIGURATION
-- ===================================
-- WezTerm will use your default shell (set via 'chsh -s $(which fish)')
-- No need to hardcode the path here as it varies by Mac architecture

-- ===================================
-- SYSTEM SPECIFIC (macOS)
-- ===================================

-- PERFORMANCE
config.max_fps = 120
config.animation_fps = 60

-- CURSOR
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 800

-- BELL
config.audible_bell = "Disabled"

-- KEY BINDINGS
config.keys = {
  -- Make Option key work as Alt (for better terminal compatibility)
  -- This is important for some CLI tools
}

-- Send the Option key as Alt on macOS
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- AUTOMATIC THEME SWITCHING EVENT
-- Enable automatic dark/light mode switching based on macOS system appearance
wezterm.on('window-config-reloaded', function(window, pane)
  local appearance = window:get_appearance()
  local overrides = window:get_config_overrides() or {}

  if appearance:find("Dark") then
    overrides.color_scheme = 'Tokyo Night'
  else
    overrides.color_scheme = 'Catppuccin Latte'
  end

  window:set_config_overrides(overrides)
end)

return config
