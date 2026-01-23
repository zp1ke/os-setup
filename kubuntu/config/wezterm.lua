-- WezTerm Configuration for Kubuntu
-- Based on NixOS/macOS setup

local wezterm = require 'wezterm'
local config = {}

-- Use config builder if available (WezTerm 20220807-113146-c2fee766 and later)
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ===================================
-- FONT CONFIGURATION
-- ===================================
-- Using FiraCode as installed by the guide
config.font = wezterm.font('FiraCode Nerd Font')
config.font_size = 14.0

-- ===================================
-- APPEARANCE
-- ===================================
-- Automatic theme switching based on system appearance.
-- Works on KDE Plasma 5.24+ (Kubuntu 22.04+) via XDG Desktop Portal.
-- When the system theme changes, WezTerm automatically reloads this config.
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
config.window_decorations = "RESIZE" -- Hides title bar but allows resizing
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
-- Increase scrollback buffer size
config.scrollback_lines = 3500
-- Enable scroll bar for visual feedback
config.enable_scroll_bar = true

-- ===================================
-- SHELL CONFIGURATION
-- ===================================
-- Set fish as default if not set by system
-- config.default_prog = { '/usr/bin/fish', '-l' }

return config
