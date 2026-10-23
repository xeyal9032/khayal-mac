#!/bin/zsh
set -euo pipefail
mode="${1:-}"
case "$mode" in
  dark|karanlik)
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
    print -- "karanlık mod"
    ;;
  light|aydinlik|aydınlık)
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
    print -- "aydınlık mod"
    ;;
  toggle)
    osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode'
    print -- "görünüm değiştirildi"
    ;;
  *)
    print -- "usage: appearance.sh dark|light|toggle" >&2
    exit 1
    ;;
esac
