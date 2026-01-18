#!/usr/bin/env bash

# Dependencies: kwriteconfig6, kreadconfig6, qdbus6 (or qdbus)

# 1. Detect System Color Scheme
# Reads the current color scheme from KDE globals (e.g., BreezeDark, BreezeLight)
CURRENT_SCHEME=$(kreadconfig6 --file kdeglobals --group General --key ColorScheme)

# 2. Define Profiles
DARK_PROFILE="Dark.profile"
LIGHT_PROFILE="Light.profile"

# Check if scheme name contains "Dark" (case insensitive)
if [[ "${CURRENT_SCHEME,,}" == *"dark"* ]]; then
    TARGET_PROFILE="$DARK_PROFILE"
    sed -i 's/palette = ".*"/palette = "tokyo_night"/' /home/zp1ke/.config/starship.toml
    echo "System scheme is $CURRENT_SCHEME. Switching to Dark Profile."
else
    TARGET_PROFILE="$LIGHT_PROFILE"
    sed -i 's/palette = ".*"/palette = "tokyo_day"/' /home/zp1ke/.config/starship.toml
    echo "System scheme is $CURRENT_SCHEME. Switching to Light Profile."
fi

# 3. Apply to Default Config (For new Konsole windows)
# Uses kwriteconfig6 for Plasma 6
kwriteconfig6 --file konsolerc --group "Desktop Entry" --key "DefaultProfile" "$TARGET_PROFILE"

# 4. Apply to Running Instances (Optional)
# Check for qdbus executable (can be qdbus or qdbus6)
if command -v qdbus6 &> /dev/null; then
    QDBUS="qdbus6"
elif command -v qdbus &> /dev/null; then
    QDBUS="qdbus"
else
    echo "Warning: qdbus not found. Cannot update running Konsole windows."
    exit 0
fi

# This loops through all open Konsole windows and sessions and updates them
for session in $($QDBUS | grep org.kde.konsole); do
    # Get list of sessions in this window
    sessions=$($QDBUS "$session" | grep /Sessions/)
    for s in $sessions; do
        $QDBUS "$session" "$s" setProfile "$TARGET_PROFILE"
    done
done
