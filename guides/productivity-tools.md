# Productivity Tools

## Purpose
记录当前机器上新增或重点使用的生产力工具，以及最小可用用法。

## direnv
- 作用：进入项目目录时自动加载环境变量，离开目录自动卸载。
- shell 接入：已在 `~/.zshrc.d/40-tools.zsh` 中启用。
- 常用命令：

```bash
direnv allow
direnv deny
direnv reload
direnv status
```

- 最小示例：

```bash
echo 'export DATA_DIR=$PWD/data' > .envrc
echo 'PATH_add ./bin' >> .envrc
direnv allow
```

- Python 示例：

```bash
echo 'layout python' > .envrc
direnv allow
```

## just
- 作用：给项目定义统一命令入口，避免记一堆脚本和参数。
- 文件名：项目根目录 `justfile`
- 运行：

```bash
just
just dev
just test
just build
```

- 最小示例：

```make
dev:
  npm run dev

test:
  pytest -q

fmt:
  nvim --headless "+lua require('conform').format({async=false,lsp_format='fallback'})" +qa
```

## yq
- 作用：查改 YAML/TOML/XML，适合 CI、compose、配置文件。
- 常用查询：

```bash
yq '.services.web.image' docker-compose.yml
yq '.linux.arch_package_manager' ~/.config/topgrade.toml
```

- 原地修改：

```bash
yq -Yi '.misc.cleanup = true' ~/.config/topgrade.toml
```

## uv
- 作用：更快的 Python 环境、装包、运行脚本工具。
- 常用命令：

```bash
uv venv
uv pip install requests
uv run python main.py
uv run --with pandas python script.py
```

- 新项目示例：

```bash
mkdir demo && cd demo
uv venv
source .venv/bin/activate
uv pip install rich
```

## glow
- 作用：在终端里阅读 Markdown。
- 常用命令：

```bash
glow README.md
glow -p README.md
```

## Neovim Additions
- `Oil`：`<leader>e`
- `Trouble diagnostics`：`<leader>xx`
- `Trouble quickfix`：`<leader>xq`
- `TodoTelescope`：`<leader>cs`

## Suggested Project Pattern
一个常见组合：

```bash
echo 'layout python' > .envrc
cat > justfile <<'EOF'
run:
  uv run python main.py

test:
  uv run pytest -q
EOF
direnv allow
just run
```
