#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"
ROOT="${KHAYAL_ROOT:-$HOME/.cursor/skills/khayal-mac}"

name="${1:-}"
target="$("$ROOT/scripts/khayal" resolve-project "$name")"
open -a Cursor "$target"
print -- "  ${KH_CY}${KH_B}$target${KH_RST}"
if [[ -d "$target/.git" ]]; then
  git -C "$target" status -sb 2>/dev/null | head -8 | sed 's/^/  /'
  git -C "$target" log -1 --oneline 2>/dev/null | sed 's/^/  /'
else
  khayal_dim "  git yok"
fi
