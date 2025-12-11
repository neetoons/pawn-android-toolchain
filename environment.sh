#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

echo "--- 1. Setting up termux configuration and dependencies ---"
termux-setup-storage
pkg update -y
pkg install curl which -y

ACODEX_SCRIPT="https://raw.githubusercontent.com/bajrangCoder/acode-plugin-acodex/main/installServer.sh"

echo "--- Installing Acodex Server---"
if which axs >/dev/null; then
  echo "--- AcodeX Server is already installed ---"
else
  if curl -sL $ACODEX_SCRIPT | bash; then
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
  if ! curl -LO $ALPINE_URL; then
    echo "ERROR: TermuxAlpine.sh download failed " >&2
    exit 1
  fi

  if ! bash $ALPINE_SCRIPT; then
    echo "ERROR: Alpine Terminux installation has failed." >&2
    rm -f $ALPINE_SCRIPT
    exit 1
  fi
  rm -f $ALPINE_SCRIPT
  echo "Termux Alpine installed."
fi

PAWNCC_INSTALL_URL="https://raw.githubusercontent.com/neetoons/pawn-android-toolchain/refs/heads/dev/pawncc_install.sh"
PAWNCC_INSTALL_SCRIPT="install_pawncc_alpine.sh"
echo "--- Downloading pawncc installation setup script ---"

if ! curl -sL $PAWNCC_INSTALL_URL -o $PAWNCC_INSTALL_SCRIPT; then
    echo "ERROR: The pawncc install script download failed." >&2
    exit 1
fi
chmod +x $PAWNCC_INSTALL_SCRIPT
echo "pawncc installation downloaded successfully."

echo "--- Starting alpine linux ---"

startalpine <<EOF
if which curl > /dev/null; then
    echo "curl installed"
else
    apk add curl
fi
curl -sL $PAWNCC_INSTALL_URL | sh
EOF

echo "--- Cleanup Termux files ---"
rm -f $PAWNCC_INSTALL_SCRIPT

echo "Full setup finished successfully."
