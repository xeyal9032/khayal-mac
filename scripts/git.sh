#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"
ROOT="${KHAYAL_ROOT:-$HOME/.cursor/skills/khayal-mac}"
WD="$("$SCRIPT_DIR/workdir.sh" get)"
cd "$WD"

cmd="${1:-durum}"
shift || true

if ! git --version >/dev/null 2>&1; then
  khayal_err "git Xcode lisansına takılı. Bir kez: sudo xcodebuild -license"
  exit 1
fi

case "$cmd" in
  durum|status)
    print -- "  ${KH_CY}${KH_B}$WD${KH_RST}"
    if [[ ! -d .git ]]; then
      khayal_dim "git yok — khayal git init"
      exit 0
    fi
    git status -sb | sed 's/^/  /'
    print -- ""
    git remote -v | sed 's/^/  /' || true
    print -- ""
    git log -1 --oneline 2>/dev/null | sed 's/^/  /' || true
    if command -v gh >/dev/null 2>&1; then
      gh auth status 2>&1 | head -5 | sed 's/^/  /' || true
    else
      khayal_dim "  gh yok — GitHub için: brew install gh && gh auth login"
    fi
    ;;
  init)
    [[ -d .git ]] && { khayal_ok "zaten git repo"; exit 0; }
    git init -b main
    [[ -f .gitignore ]] || cat > .gitignore <<'EOF'
.DS_Store
.env
.env.*
node_modules/
.vendor/
.idea/
*.log
EOF
    khayal_ok "git init (main) in $WD"
    ;;
  baglan|remote|github)
    url="${1:-}"
    [[ -d .git ]] || git init -b main
    if [[ -n "$url" ]]; then
      if git remote get-url origin >/dev/null 2>&1; then
        git remote set-url origin "$url"
      else
        git remote add origin "$url"
      fi
      khayal_ok "origin → $url"
      git push -u origin HEAD 2>/dev/null || khayal_dim "push için: gh auth login, sonra khayal git gonder"
      exit 0
    fi
    if ! command -v gh >/dev/null 2>&1; then
      khayal_dim "GitHub CLI yok. Kur: brew install gh"
      khayal_dim "veya: khayal git baglan https://github.com/KULLANICI/REPO.git"
      exit 1
    fi
    if ! gh auth status >/dev/null 2>&1; then
      print -- "GitHub girişi açılıyor…"
      gh auth login
    fi
    name="${WD:t}"
    gh repo create "$name" --private --source=. --remote=origin --push || {
      khayal_dim "repo oluşturulamadı — URL ile dene: khayal git baglan <url>"
      exit 1
    }
    khayal_ok "GitHub repo bağlandı"
    git remote -v | sed 's/^/  /'
    ;;
  kaydet|commit)
    msg="${*:-}"
    [[ -n "$msg" ]] || { print -- "örnek: khayal git kaydet ilk surum"; exit 1; }
    [[ -d .git ]] || git init -b main
    git add -A
    if ! git config user.email >/dev/null 2>&1; then
      export GIT_AUTHOR_NAME="${GIT_AUTHOR_NAME:-Khayal}"
      export GIT_AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL:-khayal@localhost}"
      export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
      export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
    fi
    if ! git commit -m "$msg"; then
      khayal_dim "commit başarısız"
      exit 1
    fi
    khayal_ok "commit: $msg"
    ;;
  gonder|push)
    git push -u origin HEAD
    khayal_ok "push edildi"
    ;;
  cek|pull)
    git pull --ff-only
    ;;
  clone)
    url="${1:-}"
    dest="${2:-}"
    [[ -n "$url" ]] || { print -- "khayal clone https://github.com/kullanici/repo.git"; exit 1; }
    base="${url:t}"
    base="${base%.git}"
    [[ -n "$dest" ]] || dest="${KHAYAL_PROJROOT:-$HOME}/$base"
    if [[ -e "$dest" ]]; then
      khayal_err "zaten var: $dest"
      exit 1
    fi
    git clone "$url" "$dest"
    "$SCRIPT_DIR/workdir.sh" set "$dest" >/dev/null
    khayal_ok "clone: $dest"
    open -a Cursor "$dest" 2>/dev/null || true
    khayal_dim "kod: khayal kod $base  ·  paketler: khayal paketler"
    ;;
  *)
    print -- "usage: git.sh durum|init|baglan [url]|kaydet <msg>|gonder|cek|clone <url>" >&2
    exit 1
    ;;
esac
