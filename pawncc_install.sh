#!/bin/sh
PAWN_VERSION="3.10.11"
echo "Updating Alpine packages"
if which pawncc > /dev/null; then
  echo "--- Pawn Compiler is already installed ---"
else
  echo "--- Installing the Pawn compiler (pawncc) ---"
  echo "Installing building dependencies"
  echo "https://dl-cdn.alpinelinux.org/alpine/v3.22/main" > /etc/apk/repositories
  apk add cmake=3.31.7-r1 alpine-sdk=1.1-r0 curl 

  PAWN_DIR="/tmp/pawn-compiler"
  echo "Downloading compiler source"
  rm -fr $PAWN_DIR "$PAWN_DIR.zip"
  curl -Lo "$PAWN_DIR.zip" "https://github.com/openmultiplayer/compiler/archive/refs/tags/v$PAWN_VERSION.zip"
  cd  /tmp/
  unzip "$PAWN_DIR.zip" 
  cd "compiler-$PAWN_VERSION/source/compiler"
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
  rm -fr "compiler-$PAWN_VERSION" "$PAWN_DIR.zip"
fi

echo "adding pawncc alias"
echo "alias pawncc='pawncc -Dgamemodes -i../qawno/include -d3 -Z \"-;+\"'" > ~/.profile
echo "alias pawncc-old='pawncc -Dgamemodes -i../pawno/include -d3 -Z \"-;+\"'" >> ~/.profile
echo "Installation finished successfully"
