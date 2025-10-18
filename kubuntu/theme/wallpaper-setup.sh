#!/bin/bash

echo "Setting up wallpaper..."

CONFIG_FILE="$HOME/.config/wallpaper-by-time.conf"
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: Config file not found at $CONFIG_FILE"
  exit 1
fi

# Get the current time as a number (e.g., 0830 for 8:30 AM)
CURRENT_TIME=$(date +%H%M)
WALLPAPER=""
LATEST_WALLPAPER_FROM_YESTERDAY=""

# Read the config file to find the correct wallpaper for the current time
while read -r config_time config_wallpaper; do
  # Store the latest wallpaper in case we need to wrap around from yesterday
  LATEST_WALLPAPER_FROM_YESTERDAY=$config_wallpaper
  # Compare the current time with the config time
  # Ensure both are treated as numbers for comparison with base-10
  if (( 10#$CURRENT_TIME >= 10#$config_time )); then
    WALLPAPER=$config_wallpaper
  fi
done < <(sort "$CONFIG_FILE") # Sort the file numerically to ensure correct order

# If no wallpaper was found for today, it means we use the last one from "yesterday"
if [[ -z "$WALLPAPER" ]]; then
  WALLPAPER=$LATEST_WALLPAPER_FROM_YESTERDAY
fi

if [[ -n "$WALLPAPER" ]]; then
  # Get all connected monitors
  MONITORS=$(xrandr --current | grep " connected" | awk '{print $1}')

  for MONITOR in $MONITORS; do
    echo "Processing monitor: $MONITOR"

    # Get monitor info including rotation
    MONITOR_INFO=$(xrandr --current | grep "^$MONITOR connected")
    echo "  Monitor info: $MONITOR_INFO"

    # Extract physical resolution (before rotation)
    PHYSICAL_RESOLUTION=$(echo "$MONITOR_INFO" | grep -o '[0-9]\+x[0-9]\+' | head -1)

    # Extract rotation info
    ROTATION=""
    if echo "$MONITOR_INFO" | grep -q " left "; then
        ROTATION="left"
    elif echo "$MONITOR_INFO" | grep -q " right "; then
        ROTATION="right"
    elif echo "$MONITOR_INFO" | grep -q " inverted "; then
        ROTATION="inverted"
    else
        ROTATION="normal"
    fi

    echo "  Monitor $MONITOR has physical resolution: $PHYSICAL_RESOLUTION, rotation: $ROTATION"

    if [[ -n "$PHYSICAL_RESOLUTION" ]]; then
      WIDTH=$(echo $PHYSICAL_RESOLUTION | cut -d'x' -f1)
      HEIGHT=$(echo $PHYSICAL_RESOLUTION | cut -d'x' -f2)

      FINAL_WALLPAPER="$WALLPAPER"

      # If height > width, we're in portrait mode for this monitor
      if (( HEIGHT > WIDTH )); then
        # Check if portrait version exists
        PORTRAIT_WALLPAPER="${WALLPAPER%.*}_portrait.${WALLPAPER##*.}"
        if [[ -f "$PORTRAIT_WALLPAPER" ]]; then
          FINAL_WALLPAPER="$PORTRAIT_WALLPAPER"
          echo "  Monitor $MONITOR is in portrait mode, using: $PORTRAIT_WALLPAPER"
        else
          echo "  Monitor $MONITOR is in portrait mode but no portrait wallpaper found: $PORTRAIT_WALLPAPER"
        fi
      else
        echo "  Monitor $MONITOR is in landscape mode, using: $FINAL_WALLPAPER"
      fi

      # Apply wallpaper to this specific monitor using kwriteconfig6
      # Get the screen number for this monitor (use word boundary to avoid partial matches)
      SCREEN_NUMS=$(xrandr --listmonitors | grep -n "\b$MONITOR\b" | cut -d: -f1)
      SCREEN_NUM=$(echo "$SCREEN_NUMS" | head -1)  # Take first match only
      echo "  Found screen numbers: $SCREEN_NUMS, using: $SCREEN_NUM"

      if [[ -n "$SCREEN_NUM" ]]; then
        # Find existing Containment IDs from the plasma config file
        PLASMA_CONFIG="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"

        # Get all existing Containment IDs that have wallpaper sections
        CONTAINMENT_IDS=$(grep -o '\[Containments\]\[[0-9]\+\]\[Wallpaper\]' "$PLASMA_CONFIG" 2>/dev/null | grep -o '\[[0-9]\+\]' | tr -d '[]' | sort -n)
        echo "  Available containment IDs: $CONTAINMENT_IDS"

        # Convert screen number to array index (1-based to 0-based)
        SCREEN_INDEX=$((SCREEN_NUM - 1))
        echo "  Screen $SCREEN_NUM -> Index $SCREEN_INDEX"

        # Get the nth Containment ID (where n is the screen index)
        CONTAINMENT_ID=$(echo "$CONTAINMENT_IDS" | sed -n "$((SCREEN_INDEX + 1))p")
        echo "  Selected containment ID: $CONTAINMENT_ID"

        if [[ -n "$CONTAINMENT_ID" ]]; then
          # Set wallpaper for this specific containment
          kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc \
            --group Containments \
            --group "$CONTAINMENT_ID" \
            --group Wallpaper \
            --group org.kde.image \
            --group General \
            --key Image "$FINAL_WALLPAPER"

          # Set FillMode if it's missing
          kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc \
            --group Containments \
            --group "$CONTAINMENT_ID" \
            --group Wallpaper \
            --group org.kde.image \
            --group General \
            --key FillMode "0"

          # Add timestamp to track when script last updated this containment
          TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
          kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc \
            --group Containments \
            --group "$CONTAINMENT_ID" \
            --group Wallpaper \
            --group org.kde.image \
            --group General \
            --key LastUpdatedByScript "$TIMESTAMP"

          echo "  Applied wallpaper to containment $CONTAINMENT_ID (screen $SCREEN_NUM, $MONITOR)"
        else
          echo "  Could not find containment ID for screen $SCREEN_NUM ($MONITOR)"
        fi

        echo "  Applied wallpaper to screen $SCREEN_INDEX ($MONITOR)"
      else
        echo "  Could not determine screen number for monitor $MONITOR"
      fi
    else
      echo "  Could not determine resolution for monitor $MONITOR"
    fi
  done

  # Reload plasma desktop to apply changes
  # First apply a global wallpaper to trigger the wallpaper system
  plasma-apply-wallpaperimage -f stretch "$WALLPAPER"

  # Give it a moment to process
  sleep 1

  # Force plasma to reload desktop configuration
  if command -v qdbus6 >/dev/null 2>&1; then
    qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'desktops().forEach(d => d.reloadConfig())'
  elif command -v qdbus >/dev/null 2>&1; then
    qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'desktops().forEach(d => d.reloadConfig())'
  else
    echo "  Warning: No D-Bus tool found. Trying alternative reload method..."
    # Alternative: restart plasmashell (more aggressive but effective)
    killall plasmashell 2>/dev/null
    sleep 2
    nohup plasmashell >/dev/null 2>&1 &
  fi

  # Set lock screen wallpaper (uses the base wallpaper, not monitor-specific)
  kwriteconfig6 --file kscreenlockerrc \
    --group Greeter \
    --group Wallpaper \
    --group org.kde.image \
    --group General \
    --key Image "file://$WALLPAPER"

  echo "Wallpaper configuration completed"
else
  echo "Could not determine wallpaper from config."
fi
