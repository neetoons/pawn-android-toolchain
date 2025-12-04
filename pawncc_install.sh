set -eu

echo "Updating Alpine packages"
apk update
apk upgrade

if which pawncc > /dev/null; then
  echo "--- Pawn Compiler is already installed ---"
else
  echo "--- Installing the Pawn compiler (pawncc) ---"
  echo "Installing building dependencies"
  apk add git cmake alpine-sdk linux-headers

  PAWN_DIR="/tmp/pawn-compiler"
  echo "Cloning compiler source"
  rm -fr "\$PAWN_DIR"
  git clone https://github.com/openmultiplayer/compiler.git "\$PAWN_DIR"

  cd "\$PAWN_DIR/source/compiler"
  echo "Starting building"
  mkdir build
  cd build
  cmake .. -DCMAKE_BUILD_TYPE=Release -Wno-dev
  make -j\$(nproc)

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
  rm -fr "\$PAWN_DIR"
fi

echo "adding pawncc alias"
echo "alias pawncc='pawncc -Dgamemodes -i../qawno/include -d3 -Z \"-;+\"'" > ~/.profile
echo "alias pawncc-old='pawncc -Dgamemodes -i../pawno/include -d3 -Z \"-;+\"'" >> ~/.profile
echo "Installation finished successfully"
