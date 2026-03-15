#!/usr/bin/env bash
set -euo pipefail

pass() { printf '[ok] %s\n' "$*"; }
warn() { printf '[warn] %s\n' "$*"; }
fail() { printf '[fail] %s\n' "$*"; }

check_cmd() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    pass "command present: $cmd"
  else
    fail "missing command: $cmd"
  fi
}

check_file() {
  local path="$1"
  if [[ -e "$path" ]]; then
    pass "path present: $path"
  else
    fail "missing path: $path"
  fi
}

check_symlink_target() {
  local path="$1"
  if [[ -L "$path" ]]; then
    pass "symlink present: $path -> $(readlink "$path")"
  else
    warn "not a symlink: $path"
  fi
}

check_git_identity() {
  local name email
  name="$(git config --global user.name || true)"
  email="$(git config --global user.email || true)"
  [[ -n "$name" ]] && pass "git user.name set: $name" || warn "git user.name not set"
  [[ -n "$email" ]] && pass "git user.email set: $email" || warn "git user.email not set"
}

check_gh_auth() {
  if gh auth status >/dev/null 2>&1; then
    pass "gh auth status ok"
  else
    warn "gh auth not ready"
  fi
}

check_ssh_dir() {
  [[ -d "$HOME/.ssh" ]] && pass "~/.ssh exists" || warn "~/.ssh missing"
}

check_pacman_repos() {
  if command -v pacman >/dev/null 2>&1; then
    grep -q '^\[multilib\]$' /etc/pacman.conf && pass "multilib enabled" || warn "multilib not enabled"
    grep -q '^\[archlinuxcn\]$' /etc/pacman.conf && pass "archlinuxcn enabled" || warn "archlinuxcn not enabled"
  fi
}

check_user_unit() {
  local unit="$1"
  if systemctl --user list-unit-files "$unit" --no-legend >/dev/null 2>&1; then
    pass "user unit known: $unit"
  else
    warn "user unit unavailable: $unit"
  fi
}

check_system_unit() {
  local unit="$1"
  if systemctl list-unit-files "$unit" --no-legend >/dev/null 2>&1; then
    pass "system unit known: $unit"
  else
    warn "system unit unavailable: $unit"
  fi
}

echo "== commands =="
for cmd in git gh ssh zsh nvim kitty hyprland waybar wofi fcitx5 pacman yay; do
  check_cmd "$cmd"
done

echo "== files =="
for path in \
  "$HOME/.zshrc" \
  "$HOME/.zshrc.d" \
  "$HOME/.config/nvim" \
  "$HOME/.config/waybar" \
  "$HOME/.config/fcitx5" \
  "$HOME/.config/mimeapps.list" \
  "$HOME/.config/systemd/user/mail-sync-notify.timer" \
  "$HOME/.local/bin/mail-sync-notify"; do
  check_file "$path"
done

echo "== symlinks =="
for path in \
  "$HOME/.zshrc" \
  "$HOME/.zshrc.d" \
  "$HOME/.guides" \
  "$HOME/.config/nvim" \
  "$HOME/.config/waybar"; do
  check_symlink_target "$path"
done

echo "== git / gh / ssh =="
check_git_identity
check_gh_auth
check_ssh_dir

echo "== pacman =="
check_pacman_repos

echo "== systemd =="
for unit in NetworkManager.service bluetooth.service docker.service power-profiles-daemon.service; do
  check_system_unit "$unit"
done
check_user_unit mail-sync-notify.timer

echo "health check complete"
