#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"

cmd="${1:-ps}"
shift || true

resolve_proj() {
  local proj="${1:-}"
  [[ -z "$proj" ]] && proj="$("$SCRIPT_DIR/workdir.sh" get)"
  if [[ ! -f "$proj/netlify.toml" ]]; then
    for c in "$proj" "$HOME/yeniphpfile" "$HOME/Ai Asistent" "$HOME/web1"; do
      [[ -f "$c/netlify.toml" ]] && { print -- "$c"; return 0; }
    done
  fi
  print -- "$proj"
}

case "$cmd" in
  ps|docker|konteyner)
    if ! command -v docker >/dev/null 2>&1; then
      khayal_err "Docker CLI yok"; exit 1
    fi
    if ! docker info >/dev/null 2>&1; then
      open -a Docker
      khayal_dim "Docker başlıyor — birkaç saniye sonra tekrar dene"
      exit 0
    fi
    print -- "  ${KH_YL}${KH_B}docker ps${KH_RST}"
    docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' | sed 's/^/  /'
    ;;
  yayin|netlify|status)
    proj="$(resolve_proj "${1:-}")"
    print -- "  ${KH_CY}$proj${KH_RST}"
    if [[ ! -f "$proj/netlify.toml" ]]; then
      khayal_dim "netlify.toml yok — ilk yayın: khayal yayin yap evet (klasörü publish eder)"
    fi
    (cd "$proj" && npx --yes netlify status 2>/dev/null | head -25 | sed 's/^/  /') \
      || khayal_dim "netlify status alınamadı — netlify login gerekebilir"
    khayal_dim "canlıya al: khayal yayin yap evet"
    ;;
  login)
    (cd "$("$SCRIPT_DIR/workdir.sh" get)" && npx --yes netlify login)
    ;;
  yap|deploy)
    proj="$(resolve_proj)"
    confirm=0
    for a in "$@"; do
      [[ "$a" == "evet" || "$a" == "--evet" ]] && confirm=1
      [[ -d "$a" ]] && proj="$a"
    done
    if [[ "$confirm" -eq 0 ]]; then
      khayal_dim "production: cd $proj && npx netlify deploy --prod"
      khayal_dim "onay: khayal yayin yap evet"
      exit 0
    fi
    khayal_ok "Netlify production deploy: $proj"
    (cd "$proj" && npx --yes netlify deploy --prod --open)
    ;;
  *)
    print -- "usage: docker-netlify.sh ps|yayin|login|yap evet" >&2
    exit 1
    ;;
esac
