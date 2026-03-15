#!/usr/bin/env bash
set -euo pipefail

PACMAN_CONF="/etc/pacman.conf"
MIRRORLIST="/etc/pacman.d/mirrorlist"
BACKUP_SUFFIX=".dotfiles.bak"

backup_file() {
  local file="$1"
  if [[ -f "$file" && ! -f "${file}${BACKUP_SUFFIX}" ]]; then
    sudo cp -a "$file" "${file}${BACKUP_SUFFIX}"
  fi
}

backup_file "$PACMAN_CONF"

sudo sed -i \
  -e 's/^#\?Color$/Color/' \
  -e 's/^#\?VerbosePkgLists$/VerbosePkgLists/' \
  -e 's/^#\?ParallelDownloads.*/ParallelDownloads = 5/' \
  "$PACMAN_CONF"

if ! grep -Fqx 'ILoveCandy' "$PACMAN_CONF"; then
  sudo sed -i '/^ParallelDownloads = 5$/a ILoveCandy' "$PACMAN_CONF"
fi

sudo sed -i \
  -e '/^#\[multilib\]$/s/^#//' \
  -e '/^#Include = \/etc\/pacman.d\/mirrorlist$/s/^#//' \
  "$PACMAN_CONF"

if ! grep -q '^\[archlinuxcn\]$' "$PACMAN_CONF"; then
  cat <<'EOF' | sudo tee -a "$PACMAN_CONF" >/dev/null

[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
EOF
fi

backup_file "$MIRRORLIST"
if command -v rate-mirrors >/dev/null 2>&1; then
  sudo rate-mirrors arch --max-delay 21600 > /tmp/mirrorlist.dotfiles
  sudo install -m 644 /tmp/mirrorlist.dotfiles "$MIRRORLIST"
  rm -f /tmp/mirrorlist.dotfiles
elif command -v reflector >/dev/null 2>&1; then
  sudo reflector --latest 20 --protocol https --sort rate --save "$MIRRORLIST"
fi

sudo pacman -Sy --noconfirm
if ! pacman -Q archlinuxcn-keyring >/dev/null 2>&1; then
  sudo pacman -S --noconfirm archlinuxcn-keyring
fi

echo "Arch base package manager initialization complete"
