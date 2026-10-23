#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"
WD="$("$SCRIPT_DIR/workdir.sh" get)"
cd "$WD"
TICK="$HOME/.khayal/agent-tick"
MAX_FILES=4
MAX_LINES=80

is_skip() {
  local f="$1"
  [[ "$f" == *".git/"* ]] && return 0
  [[ "$f" == *"/node_modules/"* ]] && return 0
  [[ "$f" == *"/.next/"* ]] && return 0
  [[ "$f:t" == .DS_Store ]] && return 0
  [[ "$f:t" == .env || "$f:t" == .env.* ]] && return 0
  [[ "$f" == *".png" || "$f" == *".jpg" || "$f" == *".jpeg" || "$f" == *".webp" || "$f" == *".gif" ]] && return 0
  return 1
}

print_file() {
  local f="$1" n=0
  print -- ""
  print -- "  ${KH_MG}── ${f} ──${KH_RST}"
  if command -v bat >/dev/null 2>&1; then
    bat --style=plain --paging=never --color=always --line-range ":$MAX_LINES" "$f" 2>/dev/null | sed 's/^/  /'
    return
  fi
  while IFS= read -r line || [[ -n "$line" ]]; do
    n=$((n+1))
    if (( n > MAX_LINES )); then
      khayal_dim "  … $(( $(wc -l < "$f") - MAX_LINES )) satır daha  ·  khayal bak $f"
      break
    fi
    printf "  ${KH_DIM}%3d${KH_RST} %s\n" "$n" "$line"
  done < "$f"
}

cmd="${1:-son}"
shift 2>/dev/null || true

case "$cmd" in
  bak|cat|oku)
    f="${1:-}"
    [[ -n "$f" ]] || { khayal_dim "khayal bak index.html"; exit 1; }
    if [[ -f "$f" ]]; then
      :
    elif [[ -f "$WD/$f" ]]; then
      f="$WD/$f"
    else
      khayal_err "dosya yok: $f"
      exit 1
    fi
    print_file "$f"
    ;;
  diff)
    if [[ -d .git ]]; then
      print -- "  ${KH_CY}${KH_B}diff${KH_RST}  ${KH_DIM}$WD${KH_RST}"
      khayal_hr
      git -c color.ui=always diff --stat HEAD 2>/dev/null | sed 's/^/  /' || true
      print -- ""
      git -c color.ui=always diff HEAD 2>/dev/null | head -n 200 | sed 's/^/  /' || true
    else
      khayal_dim "git yok — khayal bak <dosya>"
    fi
    ;;
  son|--son|"")
    print -- ""
    print -- "  ${KH_CY}${KH_B}yazılan kod${KH_RST}  ${KH_DIM}$WD${KH_RST}"
    khayal_hr
    files=()
    if [[ -f "$TICK" ]]; then
      while IFS= read -r f; do
        is_skip "$f" && continue
        files+=("$f")
      done < <(find "$WD" -type f -newer "$TICK" ! -path '*/.git/*' ! -path '*/node_modules/*' 2>/dev/null | sed "s#^$WD/##")
    fi
    if (( ${#files} == 0 )) && [[ -d .git ]]; then
      while IFS= read -r f; do
        [[ -z "$f" ]] && continue
        is_skip "$f" && continue
        files+=("$f")
      done < <(git -C "$WD" diff --name-only HEAD 2>/dev/null; git -C "$WD" ls-files --others --exclude-standard 2>/dev/null)
    fi
    if (( ${#files} == 0 )); then
      khayal_dim "bu turda dosya yazılmadı"
      print -- ""
      exit 0
    fi
    i=0
    for f in "${files[@]}"; do
      print -- "  ${KH_YL}•${KH_RST}  $f"
    done
    for f in "${files[@]}"; do
      i=$((i+1))
      if (( i > MAX_FILES )); then
        khayal_dim "kalan için: khayal bak <dosya>  ·  khayal diff"
        break
      fi
      [[ -f "$WD/$f" ]] && print_file "$WD/$f"
    done
    print -- ""
    khayal_dim "tamamı: khayal bak <dosya>  ·  khayal diff"
    ;;
  *)
    print -- "usage: goster.sh son|diff|bak <dosya>" >&2
    exit 1
    ;;
esac
