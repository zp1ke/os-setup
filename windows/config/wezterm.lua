-- WezTerm Configuration
-- Windows optimized template

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
config.font_size = 11.0

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
config.scrollback_lines = 3500
config.enable_scroll_bar = true

-- ===================================
-- SHELL CONFIGURATION
-- ===================================
-- Default to PowerShell on Windows
config.default_prog = { 'pwsh.exe', '-NoLogo' }

-- ===================================
-- SYSTEM SPECIFIC (Windows)
-- ===================================
-- Windows: theme changes are detected via system appearance

-- Performance optimizations for Windows
config.front_end = "WebGpu"
config.max_fps = 60

return config
