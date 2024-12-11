# clone kodi-repository
echo "Cloning Kodi repository..."
cd ~
git clone -b Omega https://github.com/xbmc/xbmc kodi
cd kodi

# configure with CMake
echo "Configuring the build with CMake..."
cmake ../kodi -DCMAKE_INSTALL_PREFIX=/usr/local -DCORE_PLATFORM_NAME=x11 -DAPP_RENDER_SYSTEM=gl -DENABLE_INTERNAL_FLATBUFFERS=ON

# assemble
echo "Building Kodi..."
cmake --build . -- VERBOSE=1 -j$(getconf _NPROCESSORS_ONLN)

# install and crate .deb package
echo "Installing Kodi..."
sudo make install
sudo checkinstall

# compile and install binary-addons
echo "Building and installing binary-addons..."
sudo make -j$(getconf _NPROCESSORS_ONLN) -C tools/depends/target/binary-addons PREFIX=/usr/local
