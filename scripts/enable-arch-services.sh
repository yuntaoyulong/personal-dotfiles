#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SYSTEM_LIST="$ROOT/services/arch/system-enable.txt"
USER_LIST="$ROOT/services/arch/user-enable.txt"

enable_if_exists() {
  local scope="$1"
  local unit="$2"

  if [[ "$scope" == "system" ]]; then
    if systemctl list-unit-files "$unit" --no-legend 2>/dev/null | grep -q "^${unit} "; then
      sudo systemctl enable --now "$unit"
    else
      printf 'skip missing system unit: %s\n' "$unit"
    fi
  else
    if systemctl --user list-unit-files "$unit" --no-legend 2>/dev/null | grep -q "^${unit} "; then
      systemctl --user enable --now "$unit"
    else
      printf 'skip missing user unit: %s\n' "$unit"
    fi
  fi
}

if [[ -f "$SYSTEM_LIST" ]]; then
  while IFS= read -r unit; do
    [[ -n "$unit" ]] || continue
    enable_if_exists system "$unit"
  done < "$SYSTEM_LIST"
fi

if [[ -f "$USER_LIST" ]]; then
  systemctl --user daemon-reload || true
  while IFS= read -r unit; do
    [[ -n "$unit" ]] || continue
    enable_if_exists user "$unit"
  done < "$USER_LIST"
fi
