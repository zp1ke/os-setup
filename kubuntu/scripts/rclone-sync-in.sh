#!/bin/bash

# Sync from Google Drive to local ~/GDrive using rclone
# Pull changes from remote

SOURCE="gdrive:GDrive"
REMOTE="$HOME/GDrive"

echo "Starting rclone sync from $SOURCE to $REMOTE..."
rclone sync "$SOURCE" "$REMOTE" --progress

if [ $? -eq 0 ]; then
    echo "Sync completed successfully."
else
    echo "Sync failed with error code $?."
    exit 1
fi
