#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"
mode="${1:-png}"

png="$("$SCRIPT_DIR/screenshot.sh")"
khayal_ok "ekran: $png"

case "$mode" in
  pdf)
    pdf="${png%.png}.pdf"
    if /usr/sbin/cupsfilter "$png" > "$pdf" 2>/dev/null; then
      khayal_ok "PDF: $pdf"
      open "$pdf"
    else
      open -a Preview "$png"
      khayal_dim "PDF dönüşümü olmadı — Preview açık, oradan Dışa Aktar"
    fi
    ;;
  acikla|explain)
    print -- "$png"
    ;;
  *)
    open "$png"
    ;;
esac
