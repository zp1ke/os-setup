#!/usr/bin/env bash

# Dependencies: brightnessctl, glue (qt tools)

# 1. Get Brightness Percentage
CURRENT=$(brightnessctl get)
MAX=$(brightnessctl max)
PERCENT=$(( 100 * CURRENT / MAX ))

# 2. Define Thresholds & Profiles
DARK_PROFILE="Dark.profile"
LIGHT_PROFILE="Light.profile"

if [ "$PERCENT" -lt 50 ]; then
    TARGET_PROFILE="$DARK_PROFILE"
    echo "Brightness ($PERCENT%) is low. Switching to Dark Profile."
else
    TARGET_PROFILE="$LIGHT_PROFILE"
    echo "Brightness ($PERCENT%) is high. Switching to Light Profile."
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
