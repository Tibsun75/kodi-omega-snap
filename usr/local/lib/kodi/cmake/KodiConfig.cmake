set(APP_NAME Kodi)
set(APP_NAME_LC kodi)
set(APP_NAME_UC KODI)
set(APP_PACKAGE org.xbmc.kodi)
set(APP_VERSION_MAJOR 21)
set(APP_VERSION_MINOR 1)
set(APP_VERSION_CODE 21.1.0)
if(NOT KODI_PREFIX)
  set(KODI_PREFIX /usr/local)
endif()
if(NOT KODI_INCLUDE_DIR)
  set(KODI_INCLUDE_DIR /usr/local/include/kodi)
endif()
if(NOT KODI_LIB_DIR)
  set(KODI_LIB_DIR /usr/local/lib/kodi)
endif()
if(NOT KODI_DATA_DIR)
  set(KODI_DATA_DIR /usr/local/share/kodi)
endif()
set(APP_RENDER_SYSTEM gl)
list(APPEND CMAKE_MODULE_PATH /usr/local/lib/kodi /usr/local/share/kodi/cmake)

string(REPLACE ";" " " ARCH_DEFINES "-DTARGET_POSIX;-DTARGET_LINUX;-D_GNU_SOURCE;-DHAVE_LINUX_UDMABUF=1;-DHAVE_LINUX_DMA_HEAP=1;-DHAVE_LINUX_DMA_BUF=1;-DHAVE_MKOSTEMP=1;-DHAVE_LINUX_MEMFD=1;-DHAVE_STATX=1;-DHAVE_SSE=1;-DHAVE_SSE2=1;-DHAVE_SSE3=1;-DHAVE_SSSE3=1;-DHAVE_SSE4_1=1")
add_definitions(${ARCH_DEFINES} -DBUILD_KODI_ADDON)

set(CORE_SYSTEM_NAME linux)
set(PLATFORM linux)
set(PLATFORM_TAG )
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(AddonHelpers)
