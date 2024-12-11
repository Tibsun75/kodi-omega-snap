# Kodi Omega Snap Package

This repository contains the necessary files to build and test the **Kodi Omega Snap Package**. Kodi is an open-source media center software that lets you play movies, music, TV shows, and more. This unofficial build includes all available plugins from the official repository and comes pre-installed with a customized configuration for ease of use.
Building Kodi with Snapcraft in the usual way can be extremely challenging. In this case, Kodi was compiled using the standard method. After running make install, the files were packaged with checkinstall and then extracted into a folder. These files are what you’ll find in this GitHub repository.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Build Instructions](#build-instructions)
- [Testing](#testing)
- [Launcher Script](#launcher-script)
- [Desktop Integration](#desktop-integration)
- [Notes](#notes)

---

## Overview

- **Version**: 21.10.0
- **Base**: Core24
- **Platform**: amd64
- **Source Code**: [Kodi Repository](https://github.com/xbmc/xbmc)
- **Snap Name**: kodi-omega

---

## Features

- Includes all official plugins.
- Pre-installed configuration files for a streamlined first launch.
- Full desktop integration with GNOME/KDE.
- Easy setup for IPTV with the **IPTV Simple Client** plugin.
- PulseAudio and X11 support for smooth operation.

---

## Requirements

- Snapcraft installed.

---

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/tibsun75/kodi-omega-snap.git
   cd kodi-omega-snap
   ```

2. Build the snap package:
   ```bash
   snapcraft
   ```

3. Install the snap package:
   ```bash
   sudo snap install kodi-omega_21.10.0_amd64.snap --dangerous
   ```

4. Launch Kodi Omega:
   ```bash
   kodi-omega
   ```

---

## Build Instructions

The `Build-Kodi-Omega.bash` script automates the compilation of Kodi Omega from source. Follow these steps:

1. Navigate to your home directory and execute:
   ```bash
   ./Build-Kodi-Omega.bash
   ```

2. The script will:
   - Clone the Kodi Omega repository.
   - Compile and install Kodi Omega.
   - Build binary addons.

---

## Launcher Script

The `launcher.sh` script handles the first-run setup for Kodi Omega by:

1. Copying pre-configured files into the Snap user directory (`$SNAP_USER_DATA`).
2. Ensuring the setup process only runs once using a marker file (`.first_run_completed`).
3. Starting Kodi Omega.

---

## Desktop Integration

Desktop integration is handled by the `kodi-omega.desktop` file located in `/snap/gui`. This file ensures that Kodi Omega can be launched directly from the GNOME or KDE menu.

### `kodi-omega.desktop` File

```desktop
[Desktop Entry]
Version=1.0
Name=Kodi Omega
Comment=Kodi Omega Snap Version of Open-source media center
Exec=kodi-omega
Icon=${SNAP}/meta/gui/kodi-omega.png
Terminal=false
Type=Application
Categories=AudioVideo;Video;Player;TV;
StartupNotify=true
```

---

## Notes

- The pre-configured settings are copied from the `preconfig` directory within the snap package.
- To use IPTV, ensure you have an M3U file ready and configure the **IPTV Simple Client** plugin via:
  ```
  Settings => Addons => My Addons => PVR Clients => IPTV Simple Client
  ```
- For more details on Snapcraft desktop integration, refer to the [official Snapcraft documentation](https://snapcraft.io/docs/desktop-menu-support).

