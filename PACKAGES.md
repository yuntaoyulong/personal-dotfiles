# Package Notes

This repository supports package bootstrapping during install.

## Primary Target
- `pacman` is the primary target and the best-maintained package list.
- On Arch, use the real manifests under `packages/arch/` instead of a short handcrafted package set.

## Compatibility Targets
- `apt`
- `dnf`
- `yum`

These compatibility targets are best-effort, because package names and availability vary more across distributions.

## Included Package Categories
- Shell and terminal: `zsh`, `kitty`, `starship`, `zellij`
- Search and navigation: `ripgrep`, `fd`, `fzf`, `zoxide`, `yazi`
- Editor and git: `neovim`, `git`, `github-cli`, `lazygit`
- Productivity CLI: `atuin`, `direnv`, `just`, `yq`, `uv`, `glow`, `jq`
- Desktop config dependencies: `waybar`, `wofi`, `mako`
- Monitoring and polish: `btop`, `fastfetch`, `bat`, `eza`

## Intentional Omissions
- Secrets
- Browser profiles
- Mail credentials
- Chat clients
- Language runtimes with complex policy choices beyond the current workstation defaults

## Recommendation
On Arch:

```bash
bash ./scripts/export-arch-packages.sh
./install.sh --manager pacman
```

On Debian/Ubuntu:

```bash
./install.sh --manager apt
```

On Fedora/RHEL-like systems:

```bash
./install.sh --manager dnf
```
