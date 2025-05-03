# Kodi Omega Snap Package

This repository contains the necessary files to build and test the **Kodi Omega Snap Package**. 
Kodi is an open-source media center software that lets you play movies, music, TV shows, and more. This unofficial build includes all available plugins from the official repository.

<a href="https://snapcraft.io/kodi-omega">
  <img alt="Get it from the Snap Store" src="https://snapcraft.io/en/dark/install.svg" />
</a>

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Build Instructions](#build-instructions)
- [Testing](#testing)
- [Launcher Script](#launcher-script)
- [Notes](#notes)

---

## Overview

- **Version**: 21.20.0
- **Base**: Core24
- **Platform**: amd64
- **Source Code**: [Kodi Repository](https://github.com/xbmc/xbmc)
- **Snap Name**: kodi-omega

---

## Features

- Includes all official plugins.
- Full desktop integration with GNOME/KDE.
- PulseAudio and X11 support

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
   sudo snap install kodi-omega_21.2.0_amd64.snap --dangerous
   ```

4. Launch Kodi Omega:
   ```bash
   kodi-omega
   ```

---

## Build Instructions

The `Build-Kodi-Omega.bash` script automates the compilation of Kodi Omega from source. 
Follow these steps with Ubuntu 24.04:

1. Navigate to your home directory and execute:
   ```bash
   ./Build-Kodi-Omega.bash
   ```

2. The script will:
   - Clone the Kodi Omega repository.
   - Compile and install Kodi Omega.
   - Build binary addons.

---

- For more details on Snapcraft desktop integration, refer to the [official Snapcraft documentation](https://snapcraft.io/docs/desktop-menu-support).
  

