#!/bin/zsh
set -euo pipefail
setopt NULL_GLOB

DL="${KHAYAL_DOWNLOADS:-$HOME/Downloads}"
quiet=0
[[ "${1:-}" == "--quiet" ]] && quiet=1

log() {
  if [[ "$quiet" -eq 0 ]]; then
    print -- "$*"
  fi
}

mkdir -p "$DL"

dest_for() {
  local ext="${1:l}"
  case "$ext" in
    png|jpg|jpeg|gif|webp|heic|heif|tiff|bmp|ico|svg) print -- Gorseller ;;
    mp4|mov|mkv|avi|m4v|webm) print -- Videolar ;;
    mp3|wav|aac|flac|m4a|aiff) print -- Sesler ;;
    pdf) print -- PDF ;;
    zip|rar|7z|tar|gz|tgz|bz2) print -- Arsivler ;;
    dmg|pkg|iso) print -- Kurulum ;;
    doc|docx|xls|xlsx|ppt|pptx|csv|txt|rtf|pages|numbers|key) print -- Belgeler ;;
    php|js|ts|py|rb|go|swift|html|css|json|xml|sh|zsh) print -- Kod ;;
    *) print -- Diger ;;
  esac
}

skip_name() {
  local base="$1"
  case "$base" in
    .DS_Store|.localized|Gorseller|Videolar|Sesler|PDF|Arsivler|Belgeler|Kurulum|Kod|Diger)
      return 0 ;;
  esac
  case "$base" in
    *.download|*.crdownload|*.part|*.tmp) return 0 ;;
  esac
  return 1
}

moved=0
skipped=0

for item in "$DL"/*; do
  [[ -e "$item" ]] || continue
  base="${item:t}"
  if skip_name "$base"; then
    skipped=$((skipped + 1))
    continue
  fi
  if [[ -d "$item" ]]; then
    continue
  fi
  ext="${base:e}"
  [[ -z "$ext" ]] && folder="Diger" || folder="$(dest_for "$ext")"
  mkdir -p "$DL/$folder"
  target="$DL/$folder/$base"
  if [[ -e "$target" ]]; then
    stem="${base:r}"
    target="$DL/$folder/${stem}-$(date +%Y%m%d-%H%M%S).${ext}"
  fi
  mv "$item" "$target"
  log "  → $folder/$base"
  moved=$((moved + 1))
done

if [[ "$quiet" -eq 1 ]]; then
  [[ "$moved" -gt 0 ]] && print -- "khayal downloads: $moved dosya taşındı"
  exit 0
fi

if [[ "$moved" -eq 0 ]]; then
  print -- "Downloads zaten düzenli."
else
  print -- "$moved dosya klasörlere ayrıldı."
fi
