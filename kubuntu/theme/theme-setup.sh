#!/bin/bash

echo "Setting up theme..."

CONFIG_FILE="$HOME/.config/theme-by-time.conf"
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: Config file not found at $CONFIG_FILE"
  exit 1
fi

# Get the current time as a number (e.g., 0830 for 8:30 AM)
CURRENT_TIME=$(date +%H%M)
THEME_MODE=""
LATEST_THEME_FROM_YESTERDAY=""

# Read the config file to find the correct theme for the current time
while read -r config_time config_theme; do
  # Store the latest theme in case we need to wrap around from yesterday
  LATEST_THEME_FROM_YESTERDAY=$config_theme
  # Compare the current time with the config time
  # Ensure both are treated as numbers for comparison with base-10
  if (( 10#$CURRENT_TIME >= 10#$config_time )); then
    THEME_MODE=$config_theme
  fi
done < <(sort "$CONFIG_FILE") # Sort the file numerically to ensure correct order

# If no theme was found for today, it means we use the last one from "yesterday"
if [[ -z "$THEME_MODE" ]]; then
  THEME_MODE=$LATEST_THEME_FROM_YESTERDAY
fi

if [[ -n "$THEME_MODE" ]]; then
  # Preserve the current cursor theme and size before changing the global theme
  CURSOR_THEME=$(kreadconfig6 --file "$HOME/.config/kcminputrc" --group Mouse --key cursorTheme)
  CURSOR_SIZE=$(kreadconfig6 --file "$HOME/.config/kcminputrc" --group Mouse --key cursorSize)

  # Apply the theme using lookandfeeltool
  lookandfeeltool -a "$THEME_MODE"

  # Restore the cursor theme and size using kwriteconfig6
  kwriteconfig6 --file "$HOME/.config/kcminputrc" --group Mouse --key cursorTheme "$CURSOR_THEME"
  kwriteconfig6 --file "$HOME/.config/kcminputrc" --group Mouse --key cursorSize "$CURSOR_SIZE"

  KONSOLE_COLOR_SCHEME="SolarizedLight"
  if [[ "$THEME_MODE" == *"dark"* ]]; then
    KONSOLE_COLOR_SCHEME="DarkPastels"
  fi
  # Persist color scheme for new Konsole windows by updating the default profile file
  DEFAULT_PROFILE=$(kreadconfig6 --file "$HOME/.config/konsolerc" --group "Desktop Entry" --key DefaultProfile)
  [[ -z "$DEFAULT_PROFILE" ]] && DEFAULT_PROFILE="Shell.profile"
  PROFILE_FILE="$HOME/.local/share/konsole/$DEFAULT_PROFILE"
  if [[ -f "$PROFILE_FILE" ]]; then
    kwriteconfig6 --file "$PROFILE_FILE" --group Appearance --key ColorScheme "$KONSOLE_COLOR_SCHEME"
  fi

  # Also apply to the currently open Konsole (if any)
  if command -v konsoleprofile >/dev/null 2>&1; then
    konsoleprofile colors="$KONSOLE_COLOR_SCHEME" || true
  fi

  # Set bat (batcat) theme
  BAT_THEME="OneHalfLight"
  if [[ "$THEME_MODE" == *"dark"* ]]; then
    BAT_THEME="OneHalfDark"
  fi

  # Create bat config directory if it doesn't exist
  mkdir -p "$HOME/.config/bat"

  # Write bat theme to config file
  echo "--theme=$BAT_THEME" > "$HOME/.config/bat/config"

  echo "Theme mode set to: $THEME_MODE"
else
  echo "Could not determine theme from config."
fi
