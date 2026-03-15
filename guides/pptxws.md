# PPTX Workspace Workflow

## Goal
用 Markdown 高效产出带图片的 PPT/PDF，且目录结构稳定可复用。

## Standard Commands
```bash
pptxws themes
pptxws new <workspace_name> [target_dir]
pptxws build [workspace_dir]
pptxws preview [workspace_dir]
```

## Standard Structure
- `deck.md`: 主文档
- `images/`: 图片素材
- `videos/`: 视频素材
- `layouts/`: 布局片段
- `assets/`: logo/font/icon
- `notes/`: 讲稿备注
- `exports/`: 导出产物
- `data/`: 原始数据

## Theme Rule
- 全局主题目录：`~/.config/pptxformatter/themes/`
- `deck.md` 顶部 front matter 通过 `theme: clean|dark-pro|academic` 选择风格

## Image Rule
- 优先使用相对路径：`./images/xxx.jpg`
- 优先让素材扩展名与真实格式一致（避免 `.png` 实际是 JPEG）

## Build Rule
- 导出前保存 `deck.md`
- 导出后检查 `exports/` 里 `pptx/pdf` 是否都存在
- 如图片异常，解包 `pptx` 检查 `ppt/media/*`
