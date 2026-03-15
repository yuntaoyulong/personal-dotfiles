# Standalone extract function (oh-my-zsh style), independent from any framework.
extract() {
  if (( $# == 0 )); then
    print -u2 "usage: extract <archive> [archive2 ...]"
    return 1
  fi

  local archive
  local extract_status=0

  for archive in "$@"; do
    if [[ ! -f "$archive" ]]; then
      print -u2 "extract: '$archive' is not a valid file"
      extract_status=1
      continue
    fi

    case "$archive" in
      *.tar.bz2|*.tbz2) command tar xvjf "$archive" || extract_status=1 ;;
      *.tar.gz|*.tgz)   command tar xvzf "$archive" || extract_status=1 ;;
      *.tar.xz|*.txz)   command tar xvJf "$archive" || extract_status=1 ;;
      *.tar.zst|*.tzst) command tar --zstd -xvf "$archive" || extract_status=1 ;;
      *.tar)            command tar xvf "$archive" || extract_status=1 ;;
      *.bz2)            command bunzip2 "$archive" || extract_status=1 ;;
      *.gz)             command gunzip "$archive" || extract_status=1 ;;
      *.xz)             command unxz "$archive" || extract_status=1 ;;
      *.zst)            command unzstd "$archive" || extract_status=1 ;;
      *.zip)            command unzip "$archive" || extract_status=1 ;;
      *.rar)            command unrar x "$archive" || extract_status=1 ;;
      *.7z)             command 7z x "$archive" || extract_status=1 ;;
      *.Z)              command uncompress "$archive" || extract_status=1 ;;
      *.deb)            command ar x "$archive" || extract_status=1 ;;
      *.rpm)            command rpm2cpio "$archive" | cpio -idmv || extract_status=1 ;;
      *)
        print -u2 "extract: '$archive' cannot be extracted (unsupported format)"
        extract_status=1
        ;;
    esac
  done

  return $extract_status
}

alias x='extract'
