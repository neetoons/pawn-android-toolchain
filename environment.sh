#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

echo "--- 1. Setting up termux configuration and dependencies ---"
termux-setup-storage
pkg update -y
pkg install curl git which -y

echo "--- Installing Acodex Server---"
if which axs >/dev/null; then
  echo "--- AcodeX Server is already installed ---"
else
  if curl -sL https://raw.githubusercontent.com/bajrangCoder/acode-plugin-acodex/main/installServer.sh | bash; then
    echo "Acode installed finished successfully."
  else
    echo "ERROR: The Acodex Terminal installation has failed." >&2
    exit 1
  fi
fi

echo "--- Installing Termux Alpine ---"

ALPINE_SCRIPT="TermuxAlpine.sh"
ALPINE_URL="https://raw.githubusercontent.com/Hax4us/TermuxAlpine/master/TermuxAlpine.sh"

if which startalpine >/dev/null; then
  echo "--- Termux Alpine is already installed ---"
else
  if ! curl -LO "$ALPINE_URL"; then
    echo "ERROR: TermuxAlpine.sh download failed " >&2
    exit 1
  fi

  if ! bash "$ALPINE_SCRIPT"; then
    echo "ERROR: Alpine Terminux installation has failed." >&2
    rm -f "$ALPINE_SCRIPT"
    exit 1
  fi
  rm -f "$ALPINE_SCRIPT"
  echo "Termux Alpine installed."
fi

echo "--- Starting alpine linux ---"

startalpine <<EOF
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
source ~/.profile
echo "Installation finished successfully"
EOF
