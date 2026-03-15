# Hyprland Workflow

## Core Intent
Hyprland 负责“操作系统级效率”，快捷键必须稳定、可记忆。

## Current Important Binds
- `Super + Shift + M`：电源菜单（wofi，和 Waybar 电源按钮一致）
- `Super + Shift + R`：hyprcap 录屏
- 截图快捷键：hyprshot 系列

## Consistency Rule
- Waybar 按钮行为必须与快捷键行为一致
- 脚本统一放 `~/.config/hypr/scripts/`
- 新增绑定后必须 `hyprctl reload` 并实测

## Safety Rule
- 改键位时避免覆盖高频动作
- 桌面层改动先小步验证，再扩展
