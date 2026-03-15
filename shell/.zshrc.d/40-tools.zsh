# Toolchain init
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
eval "$(thefuck --alias fix)"
eval "$(atuin init zsh)"

# Atuin key bindings
bindkey '^[[A' _atuin_up_search_widget
bindkey '^[OA' _atuin_up_search_widget
bindkey '^r' _atuin_search_widget

# ccache toggleable defaults
if command -v ccache >/dev/null 2>&1; then
  : "${USE_CCACHE:=1}"
  export CCACHE_DIR="${CCACHE_DIR:-$HOME/.cache/ccache}"
  export CCACHE_MAXSIZE="${CCACHE_MAXSIZE:-20G}"
  mkdir -p "$CCACHE_DIR"

  ccache-on() {
    export USE_CCACHE=1
    export CC='ccache gcc'
    export CXX='ccache g++'
    export CMAKE_C_COMPILER_LAUNCHER='ccache'
    export CMAKE_CXX_COMPILER_LAUNCHER='ccache'
    echo 'ccache: ON'
  }

  ccache-off() {
    export USE_CCACHE=0
    unset CC CXX CMAKE_C_COMPILER_LAUNCHER CMAKE_CXX_COMPILER_LAUNCHER
    echo 'ccache: OFF'
  }

  ccache-status() {
    echo "USE_CCACHE=${USE_CCACHE:-0}"
    echo "CC=${CC:-<unset>}"
    echo "CXX=${CXX:-<unset>}"
    ccache -s | sed -n '1,12p'
  }

  if [[ "${USE_CCACHE}" == "1" ]]; then
    ccache-on >/dev/null
  fi
fi
