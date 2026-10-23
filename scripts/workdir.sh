#!/bin/zsh
set -euo pipefail
FILE="$HOME/.khayal/workdir"
mkdir -p "$HOME/.khayal"

case "${1:-get}" in
  get)
    if [[ -n "${KHAYAL_WORKDIR:-}" && -d "${KHAYAL_WORKDIR}" ]]; then
      print -- "$KHAYAL_WORKDIR"
    elif [[ -f "$FILE" ]]; then
      dir="$(cat "$FILE")"
      [[ -d "$dir" ]] && print -- "$dir" || print -- "$PWD"
    else
      print -- "$PWD"
    fi
    ;;
  set)
    dir="${2:-$PWD}"
    [[ -d "$dir" ]] || { print -- "klasör yok: $dir" >&2; exit 1; }
    print -r -- "$dir" > "$FILE"
    print -- "$dir"
    ;;
esac
