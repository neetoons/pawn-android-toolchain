#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

echo "--- 1. Setting up termux configuration and dependencies ---"
termux-setup-storage
pkg update -y
pkg install curl git -y

echo "--- Installing Acode plugin ---"
if curl -sL https://raw.githubusercontent.com/bajrangCoder/acode-plugin-acodex/main/installServer.sh | bash; then
  echo "Acode installed finished successfully."
else
  echo "ERROR: The Acode plugin installation has failed." >&2
  exit 1
fi

echo "--- Installing Termux Alpine ---"
ALPINE_SCRIPT="TermuxAlpine.sh"
ALPINE_URL="https://raw.githubusercontent.com/Hax4us/TermuxAlpine/master/TermuxAlpine.sh"

if ! curl -LO "$ALPINE_URL"; then
  echo "ERROR: TermuxAlpine.sh download failed " >&2
  exit 1
fi

echo "Starting Alpine installation ..."
if ! bash "$ALPINE_SCRIPT"; then
  echo "ERROR: Alpine Terminux installation has failed." >&2
  rm -f "$ALPINE_SCRIPT"
  exit 1
fi
rm -f "$ALPINE_SCRIPT"
echo "Termux Alpine installed."

echo "--- Building and Installing the Pawn compiler (pawncc) ---"

startalpine <<EOF
set -eu

echo "Starting Alpine enviroment"
echo "Updating ALpine packages"
apk update
apk upgrade
echo "Installing building dependencies"
apk add git cmake alpine-sdk linux-headers

PAWN_DIR="/tmp/pawn-compiler"
echo "Cloning compiler source
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

rm -fr "\$PAWN_DIR"
echo "alias pawncc='pawncc -Dgamemodes -i../qawno/include -d3 -Z -\(+ -;+'" >> ~/.profile
echo "alias pawncc-old='pawncc -Dgamemodes -i../pawno/include -d3 -Z -\(+ -;+'" >> ~/.profile
echo "alias install-omp='wget https://github.com/openmultiplayer/open.mp/releases/download/v1.4.0.2779/open.mp-linux-x86.tar.gz && tar -xf open.mp-linux-x86.tar.gz && cp ./Server/omp-server . && rm -fr Server open.mp-linux-x86.tar.gz'"
echo "alias install-samp='wget https://gta-multiplayer.cz/downloads/samp037svr_R2-2-1.tar.gz && tar -xf samp037svr_R2-2-1.tar.gz && cp samp03/samp03svr samp03/samp-npc . && rm -fr samp03 samp037svr_R2-2-1.tar.gz'"
source ~/.profile
pawncc -v
echo "Pawn compiler has been installed successfully in Alpine"
EOF
