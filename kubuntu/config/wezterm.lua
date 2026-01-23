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
config.font_size = 12.0

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

-- Window appearance
config.scrollback_lines = 3500

-- Remove title bar on Linux if desired, or keep generic
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false

-- ===================================
-- SCROLLBACK
-- ===================================
-- Increase scrollback buffer size (default is 3500)
config.scrollback_lines = 10000
-- Enable scroll bar for visual feedback
config.enable_scroll_bar = true

-- ===================================
-- SHELL CONFIGURATION
-- ===================================
-- Set fish as default if not set by system
-- config.default_prog = { '/usr/bin/fish', '-l' }

return config
