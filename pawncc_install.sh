#!/bin/sh
set -eu
PAWN_VERSION="v3.10.11"
echo "Updating Alpine packages"
if which pawncc > /dev/null; then
  echo "--- Pawn Compiler is already installed ---"
else
  echo "--- Installing the Pawn compiler (pawncc) ---"
  echo "Installing building dependencies"
  apk add cmake alpine-sdk linux-headers

  PAWN_DIR="/tmp/pawn-compiler"
  echo "Downloading compiler source"
  rm -fr $PAWN_DIR "$PAWN_DIR.zip"
  curl -Lo "$PAWN_DIR.zip" https://github.com/openmultiplayer/compiler/archive/refs/tags/$PAWN_VERSION.zip
  unzip "$PWN_DIR.zip" -d $PWN_DIR

  cd "$PAWN_DIR/source/compiler"
  echo "Starting building"
  mkdir build
  cd build
  cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -Wno-dev
  make

  echo "Installing pawncc and libpawnc.so /usr/bin y /usr/lib"
  mv pawncc /usr/bin/
  mv libpawnc.so /usr/lib/
  if which pawncc >/dev/null; then
    pawncc -v
    echo "Pawn compiler has been installed successfully in Alpine"
  else
    echo "ERROR: Pawn Compiler installation has failed"
    exit 1
  fi
  rm -fr $PAWN_DIR "$PAWN_DIR.zip"
fi

echo "adding pawncc alias"
echo "alias pawncc='pawncc -Dgamemodes -i../qawno/include -d3 -Z \"-;+\"'" > ~/.profile
echo "alias pawncc-old='pawncc -Dgamemodes -i../pawno/include -d3 -Z \"-;+\"'" >> ~/.profile
echo "Installation finished successfully"
