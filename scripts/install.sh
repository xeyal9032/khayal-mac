#!/bin/zsh
# Bu Mac'e kur veya zip paketle (başka Mac için).
#   zsh scripts/install.sh            # kur
#   zsh scripts/install.sh kur
#   zsh scripts/install.sh kur --cekirdek
#   zsh scripts/install.sh paketle
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
SRC="${SCRIPT_DIR:h}"
DST="${KHAYAL_DST:-$HOME/.cursor/skills/khayal-mac}"
RULE_DIR="$HOME/.cursor/rules"
ZSHRC="${KHAYAL_ZSHRC:-$HOME/.zshrc}"

if [[ -r "$SCRIPT_DIR/ui.sh" ]]; then
  source "$SCRIPT_DIR/ui.sh"
else
  khayal_ok() { print -- "ok: $*"; }
  khayal_dim() { print -- "$*"; }
  khayal_err() { print -- "hata: $*" >&2; }
fi

ZSH_BLOCK=$'# >>> khayal-mac >>>
export PATH="$HOME/.local/bin:/Applications/Cursor.app/Contents/Resources/app/bin:$PATH"
setopt NO_NOMATCH
unalias khayal 2>/dev/null
unfunction khayal 2>/dev/null
unfunction _khayal 2>/dev/null

_khayal() {
  local bin="$HOME/.cursor/skills/khayal-mac/scripts/khayal"
  case "${1:-}" in
    cd|goto)
      local target
      target="$("$bin" resolve-project "${2:-}")" || return 1
      cd "$target" && pwd
      mkdir -p "$HOME/.khayal"
      print -r -- "$target" > "$HOME/.khayal/workdir"
      ;;
    *)
      "$bin" "$@"
      ;;
  esac
}
alias khayal=\'noglob _khayal\'
alias k=\'noglob _khayal\'

command_not_found_handler() {
  if (( $# >= 2 )); then
    _khayal "$@"
    return $?
  fi
  print -u2 "zsh: command not found: $1"
  print -u2 "Ajan için: khayal $1"
  return 127
}

if [[ -o interactive && -z "${KHAYAL_GREETED:-}" ]]; then
  KHAYAL_GREETED=1
  if [[ -r "$HOME/.cursor/skills/khayal-mac/scripts/ui.sh" ]]; then
    source "$HOME/.cursor/skills/khayal-mac/scripts/ui.sh"
    khayal_greet_line
  fi
fi
# <<< khayal-mac <<<
'

write_rule() {
  mkdir -p "$RULE_DIR"
  cat > "$RULE_DIR/khayal-macbook.mdc" <<EOF
---
description: Khayal Mac identity and when to load the Mac operator skill
alwaysApply: true
---

This machine is **Khayal's Mac** (\`$HOME\`). Reply in the same language as the user's latest message (Turkish, Russian, English, Azerbaijani, or any other). Do not default to Turkish if they wrote in another language.

You operate the **entire Mac** and write **code in the workdir**: create/edit files, git init/remote/commit/push, Netlify live deploy. Read \`~/.cursor/skills/khayal-mac/SKILL.md\` and \`coding.md\`. Never say you cannot change Mac settings or cannot write files. Do not only paste code — write the files.

Terminal command: \`khayal\` / \`khayal ayar wifi\`.
EOF
}

patch_skill_identity() {
  local skill="$DST/SKILL.md"
  [[ -f "$skill" ]] || return 0
  local os_ver arch_h darwin
  os_ver="$(sw_vers -productVersion 2>/dev/null || print -- "?")"
  darwin="$(uname -r | cut -d. -f1)"
  if [[ "$(uname -m)" == "arm64" ]]; then
    arch_h="Apple Silicon"
  else
    arch_h="Intel"
  fi
  /usr/bin/python3 - "$skill" "$USER" "$HOME" "$os_ver" "$darwin" "$arch_h" <<'PY'
import pathlib, sys
p = pathlib.Path(sys.argv[1])
user, home, os_ver, darwin, arch = sys.argv[2:7]
text = p.read_text()
import re
text = re.sub(
    r"\| User / home \|.*?\|",
    f"| User / home | `{user}` / `{home}` |",
    text,
    count=1,
)
text = re.sub(
    r"\| OS \|.*?\|",
    f"| OS | macOS {os_ver} (Darwin {darwin}), {arch} |",
    text,
    count=1,
)
p.write_text(text)
PY
}

patch_zshrc() {
  touch "$ZSHRC"
  local body
  body="$(cat "$ZSHRC")"
  if print -r -- "$body" | grep -q '# >>> khayal-mac >>>'; then
    /usr/bin/python3 - "$ZSHRC" "$ZSH_BLOCK" <<'PY'
import pathlib, sys
p = pathlib.Path(sys.argv[1])
block = sys.argv[2]
text = p.read_text()
start = text.find("# >>> khayal-mac >>>")
end = text.find("# <<< khayal-mac <<<")
if start != -1 and end != -1:
    end = end + len("# <<< khayal-mac <<<")
    text = text[:start] + block.rstrip() + text[end:]
    p.write_text(text)
PY
    return 0
  fi
  if print -r -- "$body" | grep -q '_khayal()'; then
    khayal_dim "zshrc'de khayal zaten var — dokunulmadı"
    return 0
  fi
  print -- "" >> "$ZSHRC"
  print -r -- "$ZSH_BLOCK" >> "$ZSHRC"
}

copy_skill() {
  mkdir -p "${DST:h}"
  if [[ "$(realpath "$SRC" 2>/dev/null || print -- "$SRC")" == "$(realpath "$DST" 2>/dev/null || print -- "$DST")" ]]; then
    khayal_dim "skill zaten yerinde: $DST"
    return 0
  fi
  /usr/bin/ditto "$SRC" "$DST"
}

do_kur() {
  local extras=1
  if [[ "${1:-}" == "--cekirdek" ]]; then
    extras=0
  fi
  [[ -f "$SRC/SKILL.md" ]] || { khayal_err "SKILL.md yok: $SRC"; exit 1; }
  copy_skill
  chmod +x "$DST/scripts/"* 2>/dev/null || true
  mkdir -p "$HOME/.khayal/bin" "$HOME/.local/bin"
  ln -sfn "$DST/scripts/khayal" "$HOME/.local/bin/khayal"
  write_rule
  patch_skill_identity
  patch_zshrc
  if (( extras )); then
    "$DST/scripts/install-spotlight.sh" || true
    "$DST/scripts/install-daemons.sh" || true
  fi
  khayal_ok "ajan kuruldu: $DST"
  khayal_dim "yeni Terminal aç → khayal help"
  khayal_dim "Cursor CLI: curl https://cursor.com/install -fsS | bash   sonra  agent login"
  khayal_dim "Sistem Ayarları → Gizlilik → Erişilebilirlik / Otomasyon"
}

do_paketle() {
  local out="${KHAYAL_PAKET:-$HOME/Desktop/Khayal-Mac-Ajan.zip}"
  mkdir -p "${out:h}"
  rm -f "$out"
  /usr/bin/ditto -c -k --keepParent --norsrc "$SRC" "$out"
  khayal_ok "paket: $out"
  print -- ""
  print -- "  Başka Mac:"
  print -- "  1. Zip'i AirDrop / USB ile kopyala"
  print -- "  2. unzip ~/Downloads/Khayal-Mac-Ajan.zip -d /tmp"
  print -- "  3. zsh /tmp/khayal-mac/scripts/install.sh"
  print -- "  4. Yeni Terminal: khayal help"
}

cmd="${1:-kur}"
case "$cmd" in
  kur|install|"")
    do_kur "${2:-}"
    ;;
  paketle|paket|zip)
    do_paketle
    ;;
  *)
    print -- "usage: install.sh kur [--cekirdek] | paketle" >&2
    exit 1
    ;;
esac
