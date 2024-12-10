#!/bin/bash
# This script copies in first start config files by first start
# off kodi-omega
set -e

SNAP_USER_DATA="$SNAP_USER_DATA/.kodi"
PRECONFIG_DIR="$SNAP/preconfig"
FIRST_RUN_MARKER="$SNAP_USER_DATA/.first_run_completed"

echo "Start Kodi-Setup..."

# Chekc is Marker-File exists
if [ ! -f "$FIRST_RUN_MARKER" ]; then
    echo "Create user directory and copy files"
    mkdir -p "$SNAP_USER_DATA"
    cp -r "$PRECONFIG_DIR"/* "$SNAP_USER_DATA/"
    touch "$FIRST_RUN_MARKER"  # Create Marker File
    echo "Files copied successfully."
fi

# Start Kodi
exec "$SNAP/usr/local/lib/kodi/kodi-x11"
