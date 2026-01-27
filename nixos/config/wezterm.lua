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
-- config.default_prog = { '/run/current-system/sw/bin/fish', '-l' }

-- ===================================
-- SYSTEM SPECIFIC
-- ===================================
-- NixOS: no extra WezTerm overrides.

return config
