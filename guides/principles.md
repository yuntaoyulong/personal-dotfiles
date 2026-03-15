# Workflow Principles

## 1. Single Source Of Truth
- Hyprland 配置以 `~/.config/hypr/` 为准
- Neovim 配置以 `~/.config/nvim/` 为准
- 幻灯片工作流以 `pptxws + ~/.config/pptxformatter/` 为准

## 2. Reproducible First
- 能脚本化就脚本化
- 能模板化就模板化
- 能一键执行就不要手工重复

## 3. Workspace Discipline
- 每个演示/项目都必须有独立工作区
- 素材与产物分离：`images/videos` 与 `exports`
- 不把临时文件混入配置目录

## 4. Minimal Friction
- 快捷键优先于层层菜单
- 默认流程必须短路径、低心智负担
- 新功能必须与现有快捷键体系不冲突

## 5. Validate End-to-End
- 配置后必须做真实联调
- 不只看“有文件”，要看“能跑通”
- 对输出文件做实际检查（如 `pptx` 内资源、命令返回码）
