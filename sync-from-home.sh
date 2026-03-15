#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="/home/quaerendo"

copy() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  rm -rf "$dst"
  cp -a "$src" "$dst"
}

copy "$HOME_DIR/.zshrc" "$ROOT/shell/.zshrc"
copy "$HOME_DIR/.zshrc.d" "$ROOT/shell/.zshrc.d"

copy "$HOME_DIR/.config/atuin" "$ROOT/config/atuin"
copy "$HOME_DIR/.config/autostart" "$ROOT/config/autostart"
copy "$HOME_DIR/.config/fastfetch" "$ROOT/config/fastfetch"
copy "$HOME_DIR/.config/fcitx5" "$ROOT/config/fcitx5"
copy "$HOME_DIR/.config/kitty" "$ROOT/config/kitty"
copy "$HOME_DIR/.config/mako" "$ROOT/config/mako"
copy "$HOME_DIR/.config/mimeapps.list" "$ROOT/config/mimeapps.list"
copy "$HOME_DIR/.config/nvim" "$ROOT/config/nvim"
copy "$HOME_DIR/.config/systemd/user" "$ROOT/config/systemd/user"
copy "$HOME_DIR/.config/waybar" "$ROOT/config/waybar"
copy "$HOME_DIR/.config/wofi" "$ROOT/config/wofi"
copy "$HOME_DIR/.config/zellij" "$ROOT/config/zellij"
copy "$HOME_DIR/.config/starship.toml" "$ROOT/config/starship.toml"
copy "$HOME_DIR/.config/topgrade.toml" "$ROOT/config/topgrade.toml"
copy "$HOME_DIR/.guides" "$ROOT/guides"
copy "$HOME_DIR/.local/bin/mail-sync-notify" "$ROOT/local/bin/mail-sync-notify"

rm -f "$ROOT/shell/.zshrc.d/10-zinit.zsh.bak_20260306"
rm -f "$ROOT/config/zellij/config.kdl.bak"
rm -f "$ROOT/config/nvim/lazy-lock.json"
rm -f "$ROOT/config/waybar/pomodoro_state.json"

echo "Synced personal dotfiles snapshot into $ROOT"
