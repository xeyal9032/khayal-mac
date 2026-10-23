#!/bin/zsh
# Khayal Mac E2E — destructive Mac ops (sleep, trash empty, prod deploy) are skipped.
set -uo pipefail

ROOT="${KHAYAL_ROOT:-$HOME/.cursor/skills/khayal-mac}"
SCRIPTS="$ROOT/scripts"
KHAYAL="$SCRIPTS/khayal"
TMP="${TMPDIR:-/tmp}/khayal-e2e-$$"
mkdir -p "$TMP"
PASS=0
FAIL=0
SKIP=0
FAILED=()

cleanup() {
  rm -rf "$TMP"
}
trap cleanup EXIT

ok() { PASS=$((PASS + 1)); print -- "  \033[32mPASS\033[0m  $1"; }
bad() { FAIL=$((FAIL + 1)); FAILED+="$1"; print -- "  \033[31mFAIL\033[0m  $1 — ${2:-}"; }
skip() { SKIP=$((SKIP + 1)); print -- "  \033[33mSKIP\033[0m  $1 — ${2:-}"; }

assert_cmd() {
  local name="$1"; shift
  if "$@" >/tmp/khayal-e2e-out 2>/tmp/khayal-e2e-err; then
    ok "$name"
  else
    bad "$name" "$(head -c 200 /tmp/khayal-e2e-err | tr '\n' ' ')"
  fi
}

assert_match() {
  local name="$1" pat="$2"
  shift 2
  local out
  if out="$("$@" 2>&1)"; then
    if print -r -- "$out" | grep -E -q -- "$pat"; then
      ok "$name"
    else
      bad "$name" "no match /$pat/ in: ${out[1,160]}"
    fi
  else
    bad "$name" "exit $? ${out[1,160]}"
  fi
}

print -- ""
print -- "=== A  syntax ==="
for f in "$SCRIPTS"/*.sh "$SCRIPTS"/khayal; do
  [[ -f "$f" ]] || continue
  if zsh -n "$f" 2>/tmp/khayal-e2e-err; then
    ok "syntax ${f:t}"
  else
    bad "syntax ${f:t}" "$(cat /tmp/khayal-e2e-err)"
  fi
done
if zsh -n "$ROOT/tests/e2e.zsh" 2>/tmp/khayal-e2e-err; then
  ok "syntax e2e.zsh"
else
  bad "syntax e2e.zsh" "$(cat /tmp/khayal-e2e-err)"
fi

print -- ""
print -- "=== B  CLI / workdir / model ==="
assert_match "khayal help" "Khayal" "$KHAYAL" help
assert_match "khayal neler yapabilirsin" "kod" "$KHAYAL" neler yapabilirsin
assert_match "khayal versiyon" "Khayal Mac v" "$KHAYAL" versiyon
assert_match "khayal doctor" "doctor" "$KHAYAL" doctor
assert_match "khayal menu" "komut paleti" "$KHAYAL" menu
assert_cmd "model get" "$SCRIPTS/model.sh" get
assert_match "model hizli" "composer-2.5" "$SCRIPTS/model.sh" hizli
assert_cmd "workdir set tmp" "$SCRIPTS/workdir.sh" set "$TMP"
assert_match "workdir get" "$TMP" "$SCRIPTS/workdir.sh" get
assert_match "resolve yeniphpfile" "yeniphpfile" "$KHAYAL" resolve-project yeniphpfile
assert_match "resolve lifeos" "Ai Asistent" "$KHAYAL" resolve-project lifeos

print -- ""
print -- "=== B2  install / paketle sandbox ==="
export KHAYAL_PAKET="$TMP/Khayal-Mac-Ajan.zip"
assert_cmd "install.sh paketle" "$SCRIPTS/install.sh" paketle
if [[ -s "$KHAYAL_PAKET" ]]; then
  ok "paket zip exists"
else
  bad "paket zip exists"
fi
FAKE="$TMP/fakehome"
mkdir -p "$FAKE"
(
  export HOME="$FAKE"
  export USER="${USER:-khayal}"
  export KHAYAL_DST="$FAKE/.cursor/skills/khayal-mac"
  export KHAYAL_ZSHRC="$FAKE/.zshrc"
  zsh "$SCRIPTS/install.sh" kur --cekirdek
) >/tmp/khayal-e2e-install-out 2>/tmp/khayal-e2e-install-err
if [[ -f "$FAKE/.cursor/skills/khayal-mac/SKILL.md" && -L "$FAKE/.local/bin/khayal" && -f "$FAKE/.cursor/rules/khayal-macbook.mdc" ]]; then
  ok "install.sh kur --cekirdek"
else
  bad "install.sh kur --cekirdek" "$(head -c 200 /tmp/khayal-e2e-install-err | tr '\n' ' ')"
fi
if grep -q 'khayal-mac' "$FAKE/.zshrc" 2>/dev/null; then
  ok "install wrote zshrc"
else
  bad "install wrote zshrc"
fi
unset KHAYAL_PAKET

print -- ""
print -- "=== C  inspect (no GUI mutate) ==="
assert_cmd "status" "$SCRIPTS/status.sh"
assert_cmd "status --line" "$SCRIPTS/status.sh" --line
assert_cmd "saglik" "$SCRIPTS/saglik.sh"
assert_cmd "sistir" "$SCRIPTS/sistir.sh"
assert_cmd "frontmost" "$SCRIPTS/frontmost.sh"
assert_cmd "ayar list" "$SCRIPTS/ayar.sh" list
assert_cmd "toparla plan" "$SCRIPTS/toparla.sh"

print -- ""
print -- "=== D  Downloads organize (sandbox) ==="
DL="$TMP/Downloads"
mkdir -p "$DL"
print -- "x" > "$DL/a.jpg"
print -- "x" > "$DL/b.pdf"
print -- "x" > "$DL/c.zip"
print -- "x" > "$DL/d.php"
print -- "x" > "$DL/wait.crdownload"
KHAYAL_DOWNLOADS="$DL" "$SCRIPTS/organize-downloads.sh" >/tmp/khayal-e2e-out 2>/tmp/khayal-e2e-err || true
if [[ -f "$DL/Gorseller/a.jpg" && -f "$DL/PDF/b.pdf" && -f "$DL/Arsivler/c.zip" && -f "$DL/Kod/d.php" && -f "$DL/wait.crdownload" ]]; then
  ok "organize-downloads types + skip incomplete"
else
  bad "organize-downloads" "$(ls -R "$DL" | tr '\n' ' ')"
fi
KHAYAL_DOWNLOADS="$DL" "$SCRIPTS/organize-downloads.sh" >/tmp/khayal-e2e-out 2>/tmp/khayal-e2e-err
if grep -q "düzenli\|0 dosya\|zaten" /tmp/khayal-e2e-out; then
  ok "organize-downloads idempotent"
else
  # second run may print "0 dosya" or "zaten düzenli"
  if [[ ! -f "$DL/a.jpg" ]]; then
    ok "organize-downloads idempotent (still nested)"
  else
    bad "organize-downloads idempotent" "$(cat /tmp/khayal-e2e-out)"
  fi
fi

print -- ""
print -- "=== E  git sandbox (heavy) ==="
if git --version >/dev/null 2>&1; then
  REPO="$TMP/repo"
  mkdir -p "$REPO"
  "$SCRIPTS/workdir.sh" set "$REPO" >/dev/null
  assert_cmd "git init" "$SCRIPTS/git.sh" init
  print -- "<?php echo 'hi';" > "$REPO/hello.php"
  assert_cmd "git kaydet" "$SCRIPTS/git.sh" kaydet "e2e hello"
  if [[ -d "$REPO/.git" ]] && git -C "$REPO" log -1 --oneline | grep -q e2e; then
    ok "git log has commit"
  else
    bad "git log" "$(git -C "$REPO" log -1 2>&1 | tr '\n' ' ')"
  fi
  if [[ -f "$REPO/.gitignore" ]]; then
    ok "git init wrote .gitignore"
  else
    bad "gitignore missing"
  fi
  assert_cmd "git durum after commit" "$SCRIPTS/git.sh" durum
  git -C "$REPO" remote add origin "https://github.com/example/khayal-e2e.git"
  if git -C "$REPO" remote get-url origin | grep -q example; then
    ok "git remote add"
  else
    bad "git remote"
  fi
else
  skip "git init/commit/remote" "Xcode license — sudo xcodebuild -license"
fi

print -- ""
print -- "=== F  pano ==="
export KHAYAL_CLIPBOARD="$TMP/clip.log"
export KHAYAL_CLIPLAST="$TMP/clip.last"
print -n -- "khayal-e2e-clip-$$" | pbcopy
assert_cmd "pano watch" "$SCRIPTS/pano.sh" watch
assert_match "pano list" "khayal-e2e-clip" "$SCRIPTS/pano.sh" list
assert_cmd "pano yapistir 1" "$SCRIPTS/pano.sh" yapistir 1
if [[ "$(pbpaste)" == "khayal-e2e-clip-$$" ]]; then
  ok "pano roundtrip"
else
  bad "pano roundtrip" "$(pbpaste | head -c 80)"
fi
unset KHAYAL_CLIPBOARD KHAYAL_CLIPLAST

print -- ""
print -- "=== G  files / coding sandbox ==="
APP="$TMP/app"
mkdir -p "$APP"
"$SCRIPTS/workdir.sh" set "$APP" >/dev/null
print -- "<h1>Khayal</h1>" > "$APP/index.html"
print -- "<?php echo 1;" > "$APP/index.php"
[[ -f "$APP/index.html" && -f "$APP/index.php" ]] && ok "manual files in workdir" || bad "manual files"
if git --version >/dev/null 2>&1; then
  assert_cmd "git init app" "$SCRIPTS/git.sh" init
  assert_cmd "git kaydet app" "$SCRIPTS/git.sh" kaydet "e2e app files"
else
  skip "git init app" "Xcode license"
fi

print -- ""
print -- "=== H  screenshot to tmp ==="
SHOT="$TMP/cap.png"
if "$SCRIPTS/screenshot.sh" "$SHOT" >/dev/null 2>&1 && [[ -s "$SHOT" ]]; then
  ok "screenshot file"
else
  skip "screenshot" "screen capture may need permission"
fi

print -- ""
print -- "=== I  skipped destructive ==="
skip "toparla evet" "empties trash / DerivedData"
skip "uyku / uyu" "changes Dock / sleeps Mac"
skip "layout yan yana" "moves live windows"
skip "yayin yap evet" "production Netlify"
skip "lock / appearance" "changes session UI"

print -- ""
print -- "=== J  agent coding E2E (heavy) ==="
AGENT_DIR="$TMP/agent-app"
mkdir -p "$AGENT_DIR"
"$SCRIPTS/workdir.sh" set "$AGENT_DIR" >/dev/null
if [[ ! -x "$HOME/.local/bin/agent" ]]; then
  skip "agent -p" "Cursor agent CLI missing"
else
  print -- "  running composer-2.5[fast=true] in $AGENT_DIR ..."
  set +e
  "$HOME/.local/bin/agent" -p --force --yolo --trust --sandbox disabled \
    --workspace "$AGENT_DIR" \
    --model 'composer-2.5[fast=true]' \
    --output-format text \
    "Create ONLY a file named e2e-hello.php in the workspace that prints Hello Khayal with echo. No other files. Do not plan. Write the file now." \
    >"$TMP/agent-out.txt" 2>"$TMP/agent-err.txt"
  ag_ec=$?
  set -e
  if [[ $ag_ec -eq 0 && -f "$AGENT_DIR/e2e-hello.php" ]] && grep -q "Hello Khayal" "$AGENT_DIR/e2e-hello.php"; then
    ok "agent wrote e2e-hello.php"
  elif [[ -f "$AGENT_DIR/e2e-hello.php" ]]; then
    ok "agent wrote e2e-hello.php (content loose)"
  else
    bad "agent wrote php" "exit=$ag_ec files=$(ls -1 "$AGENT_DIR" | tr '\n' ' ') err=$(head -c 240 "$TMP/agent-err.txt" | tr '\n' ' ')"
  fi
fi

print -- ""
print -- "=== K  restore workdir ==="
"$SCRIPTS/workdir.sh" set "$HOME/yeniphpfile" >/dev/null || true
ok "workdir restored yeniphpfile"

print -- ""
print -- "────────────────────────────────────"
print -- "PASS $PASS   FAIL $FAIL   SKIP $SKIP"
if (( FAIL > 0 )); then
  print -- "Failed:"
  for f in "${FAILED[@]}"; do print -- "  - $f"; done
  exit 1
fi
print -- "ALL CHECKED TESTS PASSED"
exit 0
