#!/bin/bash
# This is script ist for testing purpose. 

# Removing old snap package
echo "Removing kodi-omega..."
sudo snap remove kodi-omega
if [ $? -ne 0 ]; then
  echo "Error by removing kodi-omega !"
  exit 1
fi

# Build Snapcraft
echo "Build Snap-Package with Snapcraft..."
snapcraft
if [ $? -ne 0 ]; then
  echo "Error by Snapcraft building"
  exit 1
fi

# Install new Snap-Package
echo "Installiere kodi-omega_21.10.0_amd64.snap..."
sudo snap install kodi-omega_21.10.0_amd64.snap --dangerous
if [ $? -ne 0 ]; then
  echo "Error: by kodi-omega installation"
  exit 1
fi

echo "all steps finished successfully"
