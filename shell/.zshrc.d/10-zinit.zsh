# Zinit bootstrap + trigger-based lazy plugins
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33}Installing zinit...%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" || print -P "%F{160}zinit clone failed%f"
fi
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

if [[ -o interactive ]]; then
  autoload -Uz compinit add-zsh-hook
  zinit ice lucid
  zinit light zsh-users/zsh-completions
  compinit -C
  zinit ice lucid
  zinit light Aloxaf/fzf-tab
  # Avoid terminal freeze on Ctrl-S (XON/XOFF flow control).
  stty -ixon 2>/dev/null || true

  typeset -gi __zinit_plugins_loaded=0

  _zinit_load_plugins() {
    (( __zinit_plugins_loaded )) && return 0
    __zinit_plugins_loaded=1

    zinit ice lucid
    zinit light zsh-users/zsh-syntax-highlighting

    zinit ice lucid atload"_zsh_autosuggest_start"
    zinit light zsh-users/zsh-autosuggestions

    zinit ice lucid
    zinit light MichaelAquilina/zsh-you-should-use
  }

  # First keypress triggers plugin load.
  _zinit_lazy_self_insert() {
    _zinit_load_plugins
    zle .self-insert
  }

  zle -N self-insert _zinit_lazy_self_insert

  # Fallback: if user executes command without typing in zle, load once at preexec.
  _zinit_lazy_preexec() {
    _zinit_load_plugins
    add-zsh-hook -d preexec _zinit_lazy_preexec
  }
  add-zsh-hook preexec _zinit_lazy_preexec

  # Manual trigger if needed.
  lazy-plugins-load() { _zinit_load_plugins; }
fi
