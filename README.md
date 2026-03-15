# personal-dotfiles

Personal Linux workstation configuration backup.

## Scope
- `shell/`: zsh entrypoint and modular zsh config
- `config/nvim/`: Neovim config
- `config/atuin/`, `config/kitty/`, `config/mako/`, `config/zellij/`
- `config/starship.toml`, `config/topgrade.toml`
- `config/fastfetch/`, `config/waybar/`, `config/wofi/`
- `guides/`: workflow notes and operational guides

## Not Included
- Authentication tokens
- Session/cookie/cache files
- Mail credentials
- Chat app state
- Obsidian/QQ/browser runtime data

See `SENSITIVE.md` for the excluded/private list.

## Sync From Home
Run:

```bash
./sync-from-home.sh
```

## Install To Home
Preview changes:

```bash
./install.sh --dry-run
```

Apply symlinks:

```bash
./install.sh
```

The installer:
- backs up existing files into `~/.dotfiles-backup/<timestamp>/`
- creates symlinks back into this repository
- manages `~/.zshrc`, `~/.zshrc.d`, `~/.guides`, and selected `~/.config/*`

## Publish Strategy
- Public repo: safe config only, this repository layout
- Private repo: only needed if you want to store secrets or personal runtime state

Current recommendation: keep this repo public-safe and do not commit secrets at all.
