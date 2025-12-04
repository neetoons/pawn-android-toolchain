#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

PAWNCC_INSTALL_URL="https://raw.githubusercontent.com/neetoons/pawn-android-toolchain/refs/heads/dev/pawncc_install.sh"
PAWNCC_INSTALL_SCRIPT="install_pawncc_alpine.sh"

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

echo "--- Downloading Alpine setup script ---"
if ! curl -sL "$PAWNCC_INSTALL_URL" -o "$PAWNCC_INSTALL_SCRIPT"; then
    echo "ERROR: The pawncc install script download failed." >&2
    exit 1
fi
chmod +x "$ALPINE_MODULAR_SCRIPT"
echo "Modular script downloaded successfully."

startalpine <<EOF
set -eu
/home/"$USER"/"$ALPINE_MODULAR_SCRIPT"
EOF

echo "--- Cleanup Termux files ---"
rm -f "$ALPINE_MODULAR_SCRIPT"

echo "Full setup finished successfully."
