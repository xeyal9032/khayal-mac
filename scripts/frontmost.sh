#!/bin/zsh
set -euo pipefail
osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true'
