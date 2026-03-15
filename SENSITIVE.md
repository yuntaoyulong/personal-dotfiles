# Sensitive Or Private Candidates

These paths should stay out of a public repository.

## Must Exclude
- `~/.config/gh/hosts.yml`
- `~/.config/neomutt/qq_auth_code`
- `~/.config/pulse/cookie`
- `~/.config/Kingsoft/WPSCloud\\usercenter\\secretFolder.conf`

## Exclude Runtime State
- `~/.config/obsidian/`
- `~/.config/QQ/`
- `~/.config/qqmusic/`
- `~/.config/xyz.chatboxapp.app/`
- browser profiles and caches
- app cookies, sessions, lock files, crash logs

## Review Before Publishing
- `~/.config/neomutt/neomuttrc`
- `~/.config/waybar/` custom scripts if they later embed tokens
- `~/.guides/` if they later mention private endpoints, account names, or secrets

## Recommendation
Prefer public-safe config plus local secret overlays.
If you later want secret material versioned, use a separate private repo or encrypted secret manager.
