# Neovim Workflow

## Core Intent
Neovim 是写作 + 工程 + 演示统一入口。

## Plugin Organization
- 插件声明按模块放在：`~/.config/nvim/inplug/*.vim`
- 初始化逻辑放在对应模块中（post handler）
- 避免把所有逻辑堆在 `init.vim`

## Key Capabilities
- LSP: `nvim-lspconfig + mason + mason-lspconfig`
- Git: `gitsigns + lazygit.nvim`
- Format: `conform.nvim`
- Diagnostics: `trouble.nvim`
- TODO scan: `todo-comments.nvim`
- File explorer: `oil.nvim`
- Slide export: `MarpPPT / MarpPDF / MarpPreview`

## Daily Keys (must keep stable)
- `<leader>fm`：格式化
- `<leader>gg`：LazyGit
- `<leader>e`：Oil 文件管理器
- `<leader>xx`：Trouble 诊断面板
- `<leader>xq`：Trouble quickfix 面板
- `<leader>cs`：TodoTelescope，搜索 TODO/FIXME/NOTE
- `<leader>mp`：导出 PPTX
- `<leader>md`：导出 PDF
- `<leader>mP`：预览 Marp

## C/C++ Rule
- LSP 使用 `clangd`
- 格式化使用 `clang-format --style=LLVM`
- 项目构建前先生成 `compile_commands.json`（可用 `bear -- make ...`）
