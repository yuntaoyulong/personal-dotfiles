# Aliases / helpers
alias vz='nvim ~/.zshrc'
alias sz='source ~/.zshrc'
alias ls='eza --icons'
alias ll='eza --icons -l'
alias la='eza --icons -la'
alias lt='eza --icons --tree --level=2'
alias cat='bat'
alias grep='rg'
alias find='fd'
alias ip='ip -c'
alias lg='lazygit'
alias zj='zellij'
alias x='ouch decompress'
alias ai='gh copilot'
alias cx='codex'
alias cdx='codex'
alias bye='systemctl poweroff'

google() { xdg-open "https://www.google.com/search?q=$*"; }
github() { xdg-open "https://github.com/search?q=$*"; }

_recent_files_db_path() {
  print -r -- "${ZSH_RECENT_FILES_DB:-${XDG_STATE_HOME:-$HOME/.local/state}/zsh/recent-files.log}"
}

unalias nvim vim vi 2>/dev/null

_track_recent_files() {
  local db dir arg path
  db="$(_recent_files_db_path)"
  dir="${db:h}"
  /usr/bin/mkdir -p -- "$dir" || return

  for arg in "$@"; do
    [[ -f "$arg" ]] || continue

    if path=$(/usr/bin/realpath -e -- "$arg" 2>/dev/null); then
      print -r -- "${EPOCHSECONDS}\t${path}" >> "$db"
    fi
  done
}

_nvim_auto_sudoedit_target() {
  [[ $# -eq 1 ]] || return 1
  [[ "$1" != -* ]] || return 1
  [[ -f "$1" ]] || return 1
  [[ ! -w "$1" ]] || return 1
  command -v sudoedit >/dev/null 2>&1 || return 1
  return 0
}

nvim() {
  _track_recent_files "$@"
  if _nvim_auto_sudoedit_target "$1"; then
    echo "Opening with sudoedit: $1"
    command sudoedit "$1"
    return
  fi
  command nvim "$@"
}

vim() {
  nvim "$@"
}

vi() {
  nvim "$@"
}

ch() {
  cliphist list | fzf | cliphist decode | wl-copy
}

fp() {
  fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' \
      --bind 'enter:execute(nvim {})+accept'
}

v() {
  local query file db dir

  if [[ $# -gt 0 && -f "$1" ]]; then
    nvim "$@"
    return
  fi

  query="$*"
  if [[ -n "$query" ]] && command -v zoxide >/dev/null 2>&1; then
    dir=$(zoxide query -- "$query" 2>/dev/null) || dir=""
    if [[ -n "$dir" && -d "$dir" ]]; then
      builtin cd -- "$dir" || return
      nvim .
      return
    fi
  fi

  if [[ -z "$query" ]]; then
    nvim .
    return
  fi

  db="$(_recent_files_db_path)"

  [[ -f "$db" ]] || {
    echo "No zoxide match and no recent file history for: $query" >&2
    return 1
  }

  file=$(
    /usr/bin/tac "$db" | awk -F '\t' 'NF >= 2 { print $2 }' | awk '!seen[$0]++' |
      fzf --query="$query" \
          --preview 'bat --style=numbers --color=always --line-range :500 {}' \
          --bind 'enter:accept'
  ) || return

  [[ -n "$file" ]] && nvim "$file"
}

nv() {
  local tmpfile
  tmpfile=$(mktemp)
  trap "rm -f '$tmpfile'" EXIT INT TERM HUP

  local cmd_str="$*"
  "$@" 2>&1 | sed 's/\x1b\[[0-9;]*m//g' > "$tmpfile"

  if [[ ! -s "$tmpfile" ]]; then
    echo "No output" >&2
    return 1
  fi

  local ft=""
  case "$cmd_str" in
    *json*|*jq*) ft="json" ;;
    *yaml*|*yml*) ft="yaml" ;;
    *xml*|*html*) ft="xml" ;;
    *diff*|*git*show*|*git*diff*) ft="diff" ;;
    *log*|*journal*|*dmesg*) ft="log" ;;
    *help*|*man*) ft="man" ;;
    *sh*|*bash*|*zsh*) ft="sh" ;;
    *python*|*py*) ft="python" ;;
    *go*) ft="go" ;;
    *rust*|*cargo*) ft="rust" ;;
    *sql*) ft="sql" ;;
    *)
      local mime
      mime=$(file --mime-type -b "$tmpfile")
      [[ "$mime" == "application/json" ]] && ft="json"
      ;;
  esac

  local nvim_args=("-c" "set buftype=nofile")
  if [[ -n "$ft" ]]; then
    nvim_args+=("-c" "set ft=$ft")
  else
    nvim_args+=("-c" "filetype detect")
  fi

  nvim "${nvim_args[@]}" "$tmpfile"
}

y() {
  local tmp
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [[ -n "$cwd" ]] && [[ "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

cctx() {
  local context_file="/home/quaerendo/CODEX_CONTEXT.md"
  local ts
  ts="$(date '+%Y-%m-%d %H:%M:%S %z')"

  if [[ ! -f "$context_file" ]]; then
    echo "Missing: $context_file" >&2
    return 1
  fi

  if command rg -n "^- Last Updated:" "$context_file" >/dev/null 2>&1; then
    sed -i "s|^- Last Updated:.*|- Last Updated: $ts|" "$context_file"
  else
    echo "No 'Last Updated' field found in $context_file" >&2
    return 1
  fi

  echo "Updated Last Updated -> $ts"
}

c1() {
  local out err
  out="$(mktemp)"
  err="$(mktemp)"

  if codex exec --skip-git-repo-check -o "$out" "$*" >/dev/null 2>"$err"; then
    command cat "$out"
  else
    command cat "$err" >&2
    rm -f -- "$out" "$err"
    return 1
  fi

  rm -f -- "$out" "$err"
}
