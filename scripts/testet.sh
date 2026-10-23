#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"
WD="$("$SCRIPT_DIR/workdir.sh" get)"
cd "$WD"
print -- "  ${KH_CY}${KH_B}testet${KH_RST}  ${KH_DIM}$WD${KH_RST}"
khayal_hr
fail=0

if [[ -f package.json ]] && command -v npm >/dev/null 2>&1 && grep -q '"test"' package.json; then
  if npm test; then
    khayal_ok "npm test"
  else
    khayal_err "npm test"
    fail=1
  fi
elif command -v node >/dev/null 2>&1; then
  tfiles=(tests/*.test.js(N) tests/*.test.mjs(N))
  if (( ${#tfiles} > 0 )); then
    if node --test "${tfiles[@]}"; then
      khayal_ok "node --test"
    else
      khayal_err "node --test"
      fail=1
    fi
  fi
fi

if [[ -x vendor/bin/phpunit ]]; then
  if vendor/bin/phpunit; then
    khayal_ok "phpunit"
  else
    khayal_err "phpunit"
    fail=1
  fi
elif command -v php >/dev/null 2>&1; then
  for f in **/*.php(N); do
    if ! php -l "$f" >/dev/null; then
      khayal_err "php -l $f"
      fail=1
    fi
  done
  if [[ -f tests/smoke.php ]]; then
    if php tests/smoke.php; then
      khayal_ok "php smoke"
    else
      khayal_err "php smoke"
      fail=1
    fi
  elif [[ -f index.php ]]; then
    khayal_ok "php dosyaları tarandı"
  fi
fi

if [[ ! -f package.json && ! -f index.php && ! -f composer.json ]]; then
  if [[ -f index.html ]]; then
    khayal_ok "html var"
  else
    khayal_dim "bu klasörde koşacak test yok"
  fi
fi

if (( fail )); then
  exit 1
fi
khayal_ok "testler geçti"
