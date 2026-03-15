#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME:-/home/quaerendo}"
BACKUP_ROOT="${HOME_DIR}/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=1
fi

log() {
  printf '%s\n' "$*"
}

run() {
  if (( DRY_RUN )); then
    printf '[dry-run] %s\n' "$*"
  else
    eval "$@"
  fi
}

backup_path() {
  local target="$1"
  local rel="${target#$HOME_DIR/}"
  local dest="$BACKUP_ROOT/$rel"

  run "mkdir -p \"$(dirname "$dest")\""
  run "mv \"$target\" \"$dest\""
}

link_path() {
  local src="$1"
  local target="$2"

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$src" ]]; then
      log "ok: $target"
      return
    fi
    backup_path "$target"
  elif [[ -e "$target" ]]; then
    backup_path "$target"
  fi

  run "mkdir -p \"$(dirname "$target")\""
  run "ln -sfn \"$src\" \"$target\""
  log "linked: $target -> $src"
}

link_path "$ROOT/shell/.zshrc" "$HOME_DIR/.zshrc"
link_path "$ROOT/shell/.zshrc.d" "$HOME_DIR/.zshrc.d"
link_path "$ROOT/guides" "$HOME_DIR/.guides"

link_path "$ROOT/config/atuin" "$HOME_DIR/.config/atuin"
link_path "$ROOT/config/fastfetch" "$HOME_DIR/.config/fastfetch"
link_path "$ROOT/config/kitty" "$HOME_DIR/.config/kitty"
link_path "$ROOT/config/mako" "$HOME_DIR/.config/mako"
link_path "$ROOT/config/nvim" "$HOME_DIR/.config/nvim"
link_path "$ROOT/config/waybar" "$HOME_DIR/.config/waybar"
link_path "$ROOT/config/wofi" "$HOME_DIR/.config/wofi"
link_path "$ROOT/config/zellij" "$HOME_DIR/.config/zellij"

link_path "$ROOT/config/starship.toml" "$HOME_DIR/.config/starship.toml"
link_path "$ROOT/config/topgrade.toml" "$HOME_DIR/.config/topgrade.toml"

if (( DRY_RUN )); then
  log "dry-run complete"
else
  log "install complete"
  log "backup directory: $BACKUP_ROOT"
fi
