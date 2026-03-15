#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="$ROOT/packages/arch"

mkdir -p "$OUT_DIR"

pacman -Qqen | sort > "$OUT_DIR/official.txt"
pacman -Qqem | sort > "$OUT_DIR/aur.txt"

printf 'Exported Arch package manifests to %s\n' "$OUT_DIR"
