#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"
STORE="${KHAYAL_CLIPBOARD:-$HOME/.khayal/clipboard.log}"
LASTF="${KHAYAL_CLIPLAST:-$HOME/.khayal/clipboard.last}"
mkdir -p "${STORE:h}" "$HOME/.khayal"
touch "$STORE"

is_secret() {
  local t="$1"
  if (( ${#t} > 4000 )); then return 0; fi
  [[ "$t" == *"BEGIN "* && "$t" == *"PRIVATE"* ]] && return 0
  [[ "$t" == *"-----BEGIN"* ]] && return 0
  [[ "$t" == *"api_key"* || "$t" == *"api-key"* ]] && return 0
  return 1
}

load_items() {
  items=()
  local chunk
  while IFS= read -r -d $'\x1e' chunk || [[ -n "${chunk:-}" ]]; do
    [[ -z "${chunk:-}" ]] && continue
    items+=("$chunk")
  done < "$STORE"
}

cmd="${1:-list}"
case "$cmd" in
  watch)
    cur="$(pbpaste 2>/dev/null || true)"
    if [[ -z "$cur" ]]; then exit 0; fi
    if is_secret "$cur"; then exit 0; fi
    last="$(cat "$LASTF" 2>/dev/null || true)"
    if [[ "$cur" == "$last" ]]; then exit 0; fi
    print -r -- "$cur" > "$LASTF"
    printf '\x1e%s' "$cur" >> "$STORE"
    ;;
  list|pano|"")
    if [[ ! -s "$STORE" ]]; then
      print -- "pano boş"
      exit 0
    fi
    load_items
    if (( ${#items[@]} == 0 )); then
      print -- "pano boş"
      exit 0
    fi
    n=1
    for (( idx=${#items[@]}; idx>=1 && n<=15; idx-- )); do
      t="${items[idx]}"
      t="${t//$'\n'/ }"
      print -- "  $n.  ${t[1,80]}"
      n=$((n+1))
    done
    khayal_dim "yapıştırmak: khayal yapistir 1"
    ;;
  get|yapistir)
    want="${2:-1}"
    load_items
    i=$(( ${#items[@]} - want + 1 ))
    if (( i < 1 || i > ${#items[@]} )); then
      print -- "numara yok" >&2
      exit 1
    fi
    printf '%s' "${items[i]}" | pbcopy
    khayal_ok "pano #$want yapıştırılmaya hazır (Cmd+V)"
    ;;
  *)
    print -- "usage: pano.sh list|watch|yapistir N" >&2
    exit 1
    ;;
esac
