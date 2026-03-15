#!/usr/bin/env bash
set -euo pipefail

if command -v yay >/dev/null 2>&1; then
  echo "yay already installed"
  exit 0
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
cd "$tmpdir/yay"
makepkg -si --noconfirm
