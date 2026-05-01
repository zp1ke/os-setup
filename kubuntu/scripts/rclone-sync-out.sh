#!/bin/bash

# Sync from local ~/GDrive to Google Drive using rclone
# Push changes to remote

SOURCE="$HOME/GDrive"
REMOTE="gdrive:GDrive"

echo "Starting rclone sync from $SOURCE to $REMOTE..."
rclone sync "$SOURCE" "$REMOTE" --progress

if [ $? -eq 0 ]; then
    echo "Sync completed successfully."
else
    echo "Sync failed with error code $?."
    exit 1
fi
