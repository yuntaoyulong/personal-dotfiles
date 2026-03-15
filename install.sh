#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME:-/home/quaerendo}"
BACKUP_ROOT="${HOME_DIR}/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
ARCH_PKG_DIR="$ROOT/packages/arch"

DRY_RUN=0
DO_PACKAGES=1
DO_LINKS=1
DO_ENABLE_SERVICES=1
PKG_MANAGER=""

PACMAN_PACKAGES=(
  zsh neovim kitty git github-cli
  ripgrep fd eza bat fzf zoxide starship atuin
  carapace-bin thefuck direnv just yq uv glow
  zellij lazygit yazi btop fastfetch
  wofi waybar mako jq
)

APT_PACKAGES=(
  zsh neovim kitty git gh
  ripgrep fd-find eza bat fzf zoxide starship atuin
  direnv just yq uv glow
  zellij yazi btop fastfetch
  wofi waybar jq
)

DNF_PACKAGES=(
  zsh neovim kitty git gh
  ripgrep fd-find eza bat fzf zoxide starship atuin
  direnv just yq uv glow
  zellij yazi btop fastfetch
  wofi waybar jq
)

usage() {
  cat <<'EOF'
Usage:
  ./install.sh [options]

Options:
  --dry-run         Preview actions without changing anything
  --links-only      Only back up and symlink config files
  --packages-only   Only install packages
  --no-services     Do not enable systemd services/timers
  --manager NAME    Force package manager: pacman|apt|dnf|yum
  -h, --help        Show this help

Default behavior:
  1. Install packages using the detected package manager
  2. Back up existing files and create symlinks

Notes:
  - `pacman` is the primary and best-supported path.
  - On Arch, package manifests in `packages/arch/` take precedence.
  - `apt` / `dnf` / `yum` are best-effort compatibility paths.
EOF
}

log() {
  printf '%s\n' "$*"
}

run_cmd() {
  if (( DRY_RUN )); then
    printf '[dry-run] '
    printf '%q ' "$@"
    printf '\n'
  else
    "$@"
  fi
}

ensure_parent_dir() {
  run_cmd mkdir -p "$1"
}

backup_path() {
  local target="$1"
  local rel="${target#$HOME_DIR/}"
  local dest="$BACKUP_ROOT/$rel"

  ensure_parent_dir "$(dirname "$dest")"
  run_cmd mv "$target" "$dest"
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

  ensure_parent_dir "$(dirname "$target")"
  run_cmd ln -sfn "$src" "$target"
  log "linked: $target -> $src"
}

detect_manager() {
  if [[ -n "$PKG_MANAGER" ]]; then
    printf '%s\n' "$PKG_MANAGER"
    return
  fi

  if command -v pacman >/dev/null 2>&1; then
    printf '%s\n' "pacman"
  elif command -v apt-get >/dev/null 2>&1; then
    printf '%s\n' "apt"
  elif command -v dnf >/dev/null 2>&1; then
    printf '%s\n' "dnf"
  elif command -v yum >/dev/null 2>&1; then
    printf '%s\n' "yum"
  else
    printf '%s\n' ""
  fi
}

install_packages_pacman() {
  local official_manifest="$ARCH_PKG_DIR/official.txt"
  local aur_manifest="$ARCH_PKG_DIR/aur.txt"

  log "initializing Arch package manager configuration"
  run_cmd bash "$ROOT/scripts/init-arch-base.sh"

  if [[ -f "$official_manifest" ]]; then
    log "installing Arch official packages from manifest"
    mapfile -t official_packages < "$official_manifest"
    if (( ${#official_packages[@]} > 0 )); then
      run_cmd sudo pacman -S --needed "${official_packages[@]}"
    fi
  else
    local packages=("${PACMAN_PACKAGES[@]}")
    log "installing packages with pacman"
    run_cmd sudo pacman -S --needed "${packages[@]}"
  fi

  if [[ -f "$aur_manifest" ]]; then
    mapfile -t aur_packages < "$aur_manifest"
    if (( ${#aur_packages[@]} > 0 )); then
      if ! command -v yay >/dev/null 2>&1; then
        log "yay not found; bootstrapping yay for AUR packages"
        run_cmd bash "$ROOT/scripts/bootstrap-yay.sh"
      fi
      log "installing Arch AUR packages from manifest"
      run_cmd yay -S --needed "${aur_packages[@]}"
    fi
  fi
}

install_packages_apt() {
  local packages=("${APT_PACKAGES[@]}")
  log "installing packages with apt"
  run_cmd sudo apt-get update
  run_cmd sudo apt-get install -y "${packages[@]}"
}

install_packages_dnf_like() {
  local tool="$1"
  local packages=("${DNF_PACKAGES[@]}")
  log "installing packages with $tool"
  run_cmd sudo "$tool" install -y "${packages[@]}"
}

install_packages() {
  local manager
  manager="$(detect_manager)"
  if [[ -z "$manager" ]]; then
    log "no supported package manager detected"
    return 1
  fi

  case "$manager" in
    pacman) install_packages_pacman ;;
    apt) install_packages_apt ;;
    dnf) install_packages_dnf_like dnf ;;
    yum) install_packages_dnf_like yum ;;
    *)
      log "unsupported package manager: $manager"
      return 1
      ;;
  esac
}

install_links() {
  link_path "$ROOT/shell/.zshrc" "$HOME_DIR/.zshrc"
  link_path "$ROOT/shell/.zshrc.d" "$HOME_DIR/.zshrc.d"
  link_path "$ROOT/guides" "$HOME_DIR/.guides"

  link_path "$ROOT/config/atuin" "$HOME_DIR/.config/atuin"
  link_path "$ROOT/config/autostart" "$HOME_DIR/.config/autostart"
  link_path "$ROOT/config/fastfetch" "$HOME_DIR/.config/fastfetch"
  link_path "$ROOT/config/fcitx5" "$HOME_DIR/.config/fcitx5"
  link_path "$ROOT/config/kitty" "$HOME_DIR/.config/kitty"
  link_path "$ROOT/config/mako" "$HOME_DIR/.config/mako"
  link_path "$ROOT/config/mimeapps.list" "$HOME_DIR/.config/mimeapps.list"
  link_path "$ROOT/config/nvim" "$HOME_DIR/.config/nvim"
  link_path "$ROOT/config/systemd/user" "$HOME_DIR/.config/systemd/user"
  link_path "$ROOT/config/waybar" "$HOME_DIR/.config/waybar"
  link_path "$ROOT/config/wofi" "$HOME_DIR/.config/wofi"
  link_path "$ROOT/config/zellij" "$HOME_DIR/.config/zellij"

  link_path "$ROOT/local/bin/mail-sync-notify" "$HOME_DIR/.local/bin/mail-sync-notify"
  link_path "$ROOT/config/starship.toml" "$HOME_DIR/.config/starship.toml"
  link_path "$ROOT/config/topgrade.toml" "$HOME_DIR/.config/topgrade.toml"
}

enable_services_if_needed() {
  local manager
  manager="$(detect_manager)"
  if [[ "$manager" == "pacman" ]]; then
    run_cmd bash "$ROOT/scripts/enable-arch-services.sh"
  fi
}

while (( $# > 0 )); do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    --links-only)
      DO_PACKAGES=0
      DO_LINKS=1
      ;;
    --packages-only)
      DO_PACKAGES=1
      DO_LINKS=0
      ;;
    --no-services)
      DO_ENABLE_SERVICES=0
      ;;
    --manager)
      shift
      PKG_MANAGER="${1:-}"
      if [[ -z "$PKG_MANAGER" ]]; then
        log "--manager requires a value"
        exit 1
      fi
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      log "unknown option: $1"
      usage
      exit 1
      ;;
  esac
  shift
done

if (( DO_PACKAGES )); then
  install_packages
fi

if (( DO_LINKS )); then
  install_links
fi

if (( DO_ENABLE_SERVICES )); then
  enable_services_if_needed
fi

if (( DRY_RUN )); then
  log "dry-run complete"
else
  log "install complete"
  if (( DO_LINKS )); then
    log "backup directory: $BACKUP_ROOT"
  fi
fi
