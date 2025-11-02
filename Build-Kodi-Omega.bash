#!/bin/bash
# ============================================================
# Kodi Omega Build & Packaging 
# Author: Tibsun75
# Created: 2025-11
# Description:

# Interactive build script for Kodi Omega to crate a .deb

# ============================================================

set -e

# Farben
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

# --- Prüfe Abhängigkeiten --------------------------------------------------
if ! command -v dialog &>/dev/null; then
  echo -e "${YELLOW}→ Installiere dialog ...${RESET}"
  sudo apt install -y dialog
fi

# --- Render-System ---------------------------------------------------------
exec 3>&1
RENDER=$(dialog --title "Kodi Omega Build-Konfigurator" \
  --radiolist "Wähle das Render-System:" 12 60 2 \
  1 "X11 (stabil)" ON \
  2 "Wayland (experimentell)" OFF \
  2>&1 1>&3) || exit 1
exec 3>&-
[ "$RENDER" == "1" ] && PLATFORM="x11" || PLATFORM="wayland"

# --- Audio-System ----------------------------------------------------------
exec 3>&1
AUDIO=$(dialog --title "Audio-System" \
  --radiolist "Wähle das gewünschte Audio-System:" 12 60 2 \
  1 "PulseAudio (Standard)" ON \
  2 "PipeWire (modern)" OFF \
  2>&1 1>&3) || exit 1
exec 3>&-
[ "$AUDIO" == "1" ] && AUDIO_SYS="pulseaudio" || AUDIO_SYS="pipewire"

# --- CMake Flags Auswahl ---------------------------------------------------
exec 3>&1
CMAKE_SELECTION=$(dialog --checklist "Wähle zusätzliche CMake-Optionen:" 18 70 10 \
"VAAPI"    "Video Acceleration API aktivieren" ON \
"VDPAU"    "NVIDIA VDPAU-Unterstützung" OFF \
"VULKAN"   "Vulkan Render Backend aktivieren" OFF \
"LIRC"     "Infrarot-Fernbedienung (LIRC)" OFF \
"DEBUG"    "Debug Build mit Logs" OFF \
"OPTIMIZE" "Optimierter Release Build" ON \
"TESTS"    "Unit Tests mitbauen" OFF \
2>&1 1>&3) || exit 1
exec 3>&-

# Flags zusammenbauen
CMAKE_FLAGS=""
for flag in $CMAKE_SELECTION; do
  case $flag in
    VAAPI)    CMAKE_FLAGS+=" -DENABLE_VAAPI=ON" ;;
    VDPAU)    CMAKE_FLAGS+=" -DENABLE_VDPAU=ON" ;;
    VULKAN)   CMAKE_FLAGS+=" -DENABLE_VULKAN=ON" ;;
    LIRC)     CMAKE_FLAGS+=" -DENABLE_LIRC=ON" ;;
    DEBUG)    CMAKE_FLAGS+=" -DCMAKE_BUILD_TYPE=Debug" ;;
    OPTIMIZE) CMAKE_FLAGS+=" -DCMAKE_BUILD_TYPE=Release" ;;
    TESTS)    CMAKE_FLAGS+=" -DENABLE_TESTING=ON" ;;
  esac
done

# --- Versionsvergabe -------------------------------------------------------
exec 3>&1
VERSION_METHOD=$(dialog --radiolist "Wie soll die Paketversion bestimmt werden?" 12 60 2 \
  1 "Automatisch aus Git übernehmen" ON \
  2 "Manuell eingeben" OFF \
  2>&1 1>&3) || exit 1
exec 3>&-

if [ "$VERSION_METHOD" == "2" ]; then
  exec 3>&1
  MANUAL_VERSION=$(dialog --inputbox "Gib die gewünschte Versionsnummer ein (z. B. 21.0.1):" 10 60 "" 2>&1 1>&3) || exit 1
  exec 3>&-
fi

# --- Zusammenfassung mit Abbrechen ----------------------------------------
SUMMARY="Kodi Omega Build-Konfiguration:\n\n\
Render-System: $PLATFORM\n\
Audio-System:  $AUDIO_SYS\n\
Version:       $( [ "$VERSION_METHOD" == "1" ] && echo "Automatisch (Git)" || echo "$MANUAL_VERSION" )\n\
CMake-Flags:   ${CMAKE_FLAGS:-(keine zusätzlichen Flags)}"

dialog --title "Zusammenfassung" --yesno "$SUMMARY\n\nFortfahren?" 18 70
if [ $? -ne 0 ]; then
  clear
  echo -e "${YELLOW}Abgebrochen.${RESET}"
  exit 0
fi

clear
echo -e "${GREEN}→ Starte Build-Vorgang...${RESET}"

# --- Alte Pakete entfernen -------------------------------------------------
echo -e "${YELLOW}→ Entferne alte Kodi Pakete ...${RESET}"
sudo apt purge -y kodi* || true
sudo apt autoremove -y

# --- Abhängigkeiten --------------------------------------------------------
echo -e "${YELLOW}→ Installiere Build-Abhängigkeiten ...${RESET}"
sudo apt update
sudo apt install -y autoconf automake autopoint autotools-dev cmake \
  curl debhelper default-jre doxygen gawk gcc gdc gettext gperf \
  libasound2-dev libass-dev libavahi-client-dev libavahi-common-dev \
  libbluetooth-dev libbluray-dev libbz2-dev libcdio-dev \
  libcrossguid-dev libcurl4-openssl-dev libcwiid-dev libdbus-1-dev \
  libdrm-dev libegl1-mesa-dev libenca-dev libexiv2-dev libflac-dev \
  libfmt-dev libfontconfig-dev libfreetype6-dev libfribidi-dev \
  libfstrcmp-dev libgcrypt-dev libgif-dev libgl1-mesa-dev \
  libgles2-mesa-dev libglu1-mesa-dev libgnutls28-dev libgpg-error-dev \
  libgtest-dev libiso9660-dev libjpeg-dev liblcms2-dev libltdl-dev \
  liblzo2-dev libmicrohttpd-dev libmysqlclient-dev libnfs-dev \
  libogg-dev libp8-platform-dev libpcre2-dev libplist-dev libpng-dev \
  libpulse-dev libshairplay-dev libsmbclient-dev libspdlog-dev \
  libsqlite3-dev libssl-dev libtag1-dev libtiff5-dev libtinyxml-dev \
  libtinyxml2-dev libtool libudev-dev libunistring-dev libva-dev \
  libvdpau-dev libvorbis-dev libxmu-dev libxrandr-dev libxslt1-dev \
  libxt-dev lsb-release meson nasm ninja-build nlohmann-json3-dev \
  python3-dev python3-pil python3-pip swig unzip uuid-dev zip \
  zlib1g-dev checkinstall libdav1d-dev \
  $( [ "$AUDIO_SYS" == "pipewire" ] && echo "libpipewire-0.3-dev libspa-0.2-dev" )

# --- Kodi Quelle klonen ---------------------------------------------------
cd ~
if [ -d "kodi" ]; then
  echo -e "${YELLOW}→ Entferne vorhandenes kodi-Verzeichnis ...${RESET}"
  sudo rm -rf kodi
fi

echo -e "${YELLOW}→ Klone Kodi Omega Repository ...${RESET}"
git clone -b Omega https://github.com/xbmc/xbmc kodi
cd kodi

# --- Version bestimmen ----------------------------------------------------
if [ "$VERSION_METHOD" == "1" ]; then
  KODI_VERSION=$(git describe --tags --always 2>/dev/null | sed 's/-Omega//; s/^v//')
  [ -z "$KODI_VERSION" ] && KODI_VERSION="dev-$(date +%Y%m%d)"
else
  KODI_VERSION="$MANUAL_VERSION"
fi

echo -e "${GREEN}→ Kodi-Version: ${KODI_VERSION}${RESET}"

# --- Build vorbereiten ----------------------------------------------------
mkdir -p build && cd build
echo -e "${YELLOW}→ Führe CMake aus ...${RESET}"
cmake ../ \
  -DCMAKE_INSTALL_PREFIX=/usr/local \
  -DCORE_PLATFORM_NAME=${PLATFORM} \
  -DAPP_RENDER_SYSTEM=gl \
  -DENABLE_INTERNAL_FLATBUFFERS=ON \
  ${CMAKE_FLAGS}

# --- Kompilieren ----------------------------------------------------------
echo -e "${YELLOW}→ Kompiliere Kodi (dies kann einige Minuten dauern) ...${RESET}"
cmake --build . -j$(getconf _NPROCESSORS_ONLN)

# --- Installation & Paketbau ----------------------------------------------
echo -e "${YELLOW}→ Erstelle .deb Paket mit checkinstall ...${RESET}"
sudo checkinstall -y --type=debian \
  --pkgname="kodi-omega" \
  --pkgversion="${KODI_VERSION}" \
  --provides="kodi-omega" \
  --nodoc --backup=no --install=yes --exclude=/home

# --- Abschlussdialog ------------------------------------------------------
FINAL_PKG="kodi-omega_${KODI_VERSION}-1_amd64.deb"
dialog --title "Build abgeschlossen" --msgbox "Kodi Omega Build abgeschlossen!\n\n\
Render-System: $PLATFORM\n\
Audio-System:  $AUDIO_SYS\n\
Version:       $KODI_VERSION\n\n\
Paket: $(pwd)/${FINAL_PKG}" 15 70

clear
echo -e "${GREEN}→ Build abgeschlossen.${RESET}"
echo -e "Dein Paket: $(pwd)/${FINAL_PKG}"
