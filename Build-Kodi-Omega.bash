cd ~
git clone -b Omega https://github.com/xbmc/xbmc kodi
cd kodi
cmake ../kodi -DCMAKE_INSTALL_PREFIX=/usr/local -DCORE_PLATFORM_NAME=x11 -DAPP_RENDER_SYSTEM=gl -DENABLE_INTERNAL_FLATBUFFERS=ON
cmake --build . -- VERBOSE=1 -j$(getconf _NPROCESSORS_ONLN)
sudo make install
sudo checkinstall
sudo make -j$(getconf _NPROCESSORS_ONLN) -C tools/depends/target/binary-addons PREFIX=/usr/local
