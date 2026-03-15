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
- installs baseline packages first
- backs up existing files into `~/.dotfiles-backup/<timestamp>/`
- creates symlinks back into this repository
- manages `~/.zshrc`, `~/.zshrc.d`, `~/.guides`, and selected `~/.config/*`

### Package Manager Support
- `pacman`: primary and required target
- `apt`: optional compatibility path
- `dnf` / `yum`: optional compatibility path

### Arch Full Restore
For Arch, this repo supports full package restoration from manifests:

- `packages/arch/official.txt`
- `packages/arch/aur.txt`

Refresh those manifests from the current machine:

```bash
bash ./scripts/export-arch-packages.sh
```

Then on a fresh Arch install:

```bash
bash ./install.sh --manager pacman
```

This will:
- install official packages with `pacman`
- bootstrap `yay` if needed
- install AUR packages from the manifest
- then link your config files

Examples:

```bash
./install.sh --dry-run
./install.sh --links-only
./install.sh --packages-only
./install.sh --manager pacman
./install.sh --manager apt
```

On Arch, installation is manifest-driven. On non-Arch systems, package installation stays baseline-only and best-effort.

## Publish Strategy
- Public repo: safe config only, this repository layout
- Private repo: only needed if you want to store secrets or personal runtime state

Current recommendation: keep this repo public-safe and do not commit secrets at all.
