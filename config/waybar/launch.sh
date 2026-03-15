#!/usr/bin/env bash

set -euo pipefail

pkill -x waybar 2>/dev/null || true
sleep 0.2

waybar -c /home/quaerendo/.config/waybar/config &
waybar -c /home/quaerendo/.config/waybar/config-left &
