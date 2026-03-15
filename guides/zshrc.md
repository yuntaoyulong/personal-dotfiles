# Zsh 配置使用说明（当前环境）

## 1. 配置结构

当前 `~/.zshrc` 只负责加载模块：

```zsh
for f in "$HOME/.zshrc.d"/*.zsh; do
  [ -r "$f" ] && source "$f"
done
```

也就是说，主要配置都在 `~/.zshrc.d/` 下。

## 2. 当前模块职责

- `~/.zshrc.d/00-env.zsh`：环境变量
- `~/.zshrc.d/10-zinit.zsh`：zinit + 插件加载（已改为触发式懒加载）
- `~/.zshrc.d/20-keymaps.zsh`：按键映射
- `~/.zshrc.d/30-aliases.zsh`：别名
- `~/.zshrc.d/35-extract.zsh`：独立 `extract` 插件（非 oh-my-zsh）
- `~/.zshrc.d/40-tools.zsh`：starship/zoxide/atuin/thefuck/carapace 等工具初始化

## 3. zinit 懒加载说明

`10-zinit.zsh` 现在是“用到再加载”：

- 第一次键入字符时加载插件
- 第一次按 `Tab` 补全时加载插件
- 如果直接执行命令，`preexec` 会兜底触发加载

手动触发命令：

```zsh
lazy-plugins-load
```

## 4. extract 功能

已提供独立函数（不依赖 oh-my-zsh）：

- 命令：`extract <压缩包>`
- 别名：`x <压缩包>`
- 文件位置：`~/.zshrc.d/35-extract.zsh`

示例：

```zsh
extract file.tar.gz
x a.zip b.7z
```

## 5. 常用维护操作

重载配置：

```zsh
source ~/.zshrc
```

检查某个模块是否有语法错误：

```zsh
zsh -n ~/.zshrc.d/10-zinit.zsh
```

查看是否加载了 extract：

```zsh
whence -w extract
alias x
```

## 6. 回滚 zinit 配置

你有备份：`~/.zshrc.d/10-zinit.zsh.bak_20260306`

回滚命令：

```zsh
cp ~/.zshrc.d/10-zinit.zsh.bak_20260306 ~/.zshrc.d/10-zinit.zsh
source ~/.zshrc
```
