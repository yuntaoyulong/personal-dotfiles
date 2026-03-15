# Modular zsh config loader
for f in "$HOME/.zshrc.d"/*.zsh; do
  [ -r "$f" ] && source "$f"
done

# >>> conda initialize (lazy) >>>
export PATH="/opt/miniconda3/bin:$PATH"

_lazy_load_conda() {
  unset -f conda _lazy_load_conda

  local __conda_setup
  __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [[ $? -eq 0 ]]; then
    eval "$__conda_setup"
  elif [[ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]]; then
    . "/opt/miniconda3/etc/profile.d/conda.sh"
  fi
  unset __conda_setup

  conda "$@"
}

conda() {
  _lazy_load_conda "$@"
}
# <<< conda initialize (lazy) <<<

# Build pptxws deck with auto image adaptation
ppt() {
  local deck="${1:-slides/deck.md}"
  npm run adapt-images -- "$deck" && npm run build:pptxws -- "$deck"
}
