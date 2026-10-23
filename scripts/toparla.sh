#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"

do_it=0
[[ "${1:-}" == "evet" || "${1:-}" == "--evet" ]] && do_it=1

derived="$HOME/Library/Developer/Xcode/DerivedData"
trash_n="$(osascript -e 'tell application "Finder" to get count of items of trash' 2>/dev/null || echo 0)"
dd_size="0B"
[[ -d "$derived" ]] && dd_size="$(du -sh "$derived" 2>/dev/null | awk '{print $1}')"

print -- "  ${KH_YL}${KH_B}toparla planı${KH_RST}"
print -- "  Çöp: $trash_n öğe"
print -- "  Xcode DerivedData: $dd_size"
print -- "  Downloads Diger >30 gün: taranacak"
print -- ""

if [[ "$do_it" -eq 0 ]]; then
  khayal_dim "onayla: khayal toparla evet"
  exit 0
fi

osascript -e 'tell application "Finder" to empty trash' 2>/dev/null || true
if [[ -d "$derived" ]]; then
  rm -rf "$derived"/*
fi
# old Downloads/Diger files → Trash via Finder
if [[ -d "$HOME/Downloads/Diger" ]]; then
  find "$HOME/Downloads/Diger" -type f -mtime +30 -print0 2>/dev/null \
    | while IFS= read -r -d '' f; do
        osascript -e "tell application \"Finder\" to delete POSIX file \"${f}\"" >/dev/null 2>&1 || true
      done
fi
khayal_ok "çöp boşaltıldı, DerivedData silindi, eski Diger dosyaları çöpe alındı"
"$SCRIPT_DIR/notify.sh" "Khayal" "Mac toparlandı"
