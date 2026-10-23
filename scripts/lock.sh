#!/bin/zsh
set -euo pipefail
osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}'
print -- "ekran kilitlendi"
