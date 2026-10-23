#!/bin/zsh
set -euo pipefail
SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/ui.sh"
ROOT="${KHAYAL_PROJROOT:-$HOME}"

usage() {
  print -- ""
  print -- "  ${KH_CY}${KH_B}yeni proje${KH_RST}"
  print -- ""
  khayal_key "khayal yeni php ad" "PHP + composer + smoke test"
  khayal_key "khayal yeni html ad" "statik site"
  khayal_key "khayal yeni node ad" "Node + test"
  khayal_key "khayal yeni vite ad" "Vite"
  khayal_key "khayal yeni next ad" "Next.js"
  print -- ""
  khayal_dim "sonra: khayal paketler  ·  khayal onizle  ·  khayal testet  ·  khayal git baglan"
  print -- ""
}

kind="${1:-}"
name="${2:-}"
silent=0
for a in "$@"; do
  [[ "$a" == "--sessiz" ]] && silent=1
done
if [[ "$kind" == "yeni" ]]; then
  kind="$name"
  name="${3:-}"
fi

if [[ -z "$kind" || "$kind" == "help" || -z "$name" ]]; then
  usage
  [[ -n "$name" ]] || exit 0
fi

kind="$(print -r -- "$kind" | tr '[:upper:]' '[:lower:]')"
if [[ ! "$name" =~ '^[A-Za-z0-9_-]+$' ]]; then
  khayal_err "ad sadece harf, rakam, - _"
  exit 1
fi

dest="$ROOT/$name"
if [[ -e "$dest" ]]; then
  khayal_err "zaten var: $dest"
  exit 1
fi
mkdir -p "$dest"

write_ignore() {
  cat > "$dest/.gitignore" <<'EOF'
.DS_Store
.env
.env.*
node_modules/
.vendor/
.idea/
*.log
.netlify/
EOF
}

write_netlify() {
  local pub="${1:-.}" cmd="${2:-}"
  {
    print -- '[build]'
    print -- "  publish = \"${pub}\""
    [[ -n "$cmd" ]] && print -- "  command = \"${cmd}\""
  } > "$dest/netlify.toml"
}

write_php_smoke() {
  mkdir -p "$dest/tests"
  cat > "$dest/tests/smoke.php" <<'EOF'
<?php
$root = dirname(__DIR__);
$ok = is_file($root . '/index.php');
fwrite($ok ? STDOUT : STDERR, $ok ? "ok\n" : "fail\n");
exit($ok ? 0 : 1);
EOF
}

write_node_test() {
  mkdir -p "$dest/tests"
  cat > "$dest/tests/smoke.test.mjs" <<'EOF'
import test from "node:test";
import assert from "node:assert";
test("khayal smoke", () => {
  assert.ok(true);
});
EOF
}

case "$kind" in
  php)
    cat > "$dest/index.php" <<EOF
<?php
header('Content-Type: text/html; charset=utf-8');
\$ad = '${name}';
?>
<!doctype html>
<html lang="tr">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title><?= htmlspecialchars(\$ad) ?></title>
<style>
  :root { color-scheme: dark; }
  body { margin:0; min-height:100vh; display:grid; place-items:center;
    font: 18px/1.5 ui-sans-serif, system-ui, sans-serif;
    background:#0b1220; color:#e2e8f0; }
  main { padding:2rem; border:1px solid #67e8f9; border-radius:20px; max-width:36rem; }
  h1 { margin:0 0 .5rem; color:#67e8f9; }
  p { margin:0; color:#94a3b8; }
</style>
<main>
  <h1><?= htmlspecialchars(\$ad) ?></h1>
  <p>Khayal ile oluşturuldu. <?= date('Y-m-d H:i') ?></p>
</main>
EOF
    write_netlify
    cat > "$dest/composer.json" <<EOF
{
  "name": "khayal/${name}",
  "description": "Khayal PHP",
  "require": { "php": ">=8.0" }
}
EOF
    write_php_smoke
    ;;
  html|web|site)
    kind="html"
    cat > "$dest/index.html" <<EOF
<!doctype html>
<html lang="tr">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>${name}</title>
<style>
  :root { color-scheme: dark; }
  body { margin:0; min-height:100vh; display:grid; place-items:center;
    font: 18px/1.5 ui-sans-serif, system-ui, sans-serif;
    background:#0b1220; color:#e2e8f0; }
  main { padding:2rem; border:1px solid #e879f9; border-radius:20px; max-width:36rem; }
  h1 { margin:0 0 .5rem; color:#e879f9; }
  p { margin:0; color:#94a3b8; }
</style>
<main>
  <h1>${name}</h1>
  <p>Khayal ile oluşturuldu.</p>
</main>
EOF
    write_netlify
    ;;
  node|js)
    kind="node"
    cat > "$dest/package.json" <<EOF
{
  "name": "${name}",
  "version": "1.0.0",
  "private": true,
  "scripts": { "start": "node index.js", "test": "node --test tests/smoke.test.mjs" }
}
EOF
    cat > "$dest/index.js" <<EOF
const http = require("http");
const port = process.env.PORT || 8787;
http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
  res.end("<h1>${name}</h1><p>Khayal node</p>");
}).listen(port, "127.0.0.1", () => console.log("http://127.0.0.1:" + port));
EOF
    write_netlify
    write_node_test
    ;;
  vite)
    mkdir -p "$dest/src"
    cat > "$dest/package.json" <<EOF
{
  "name": "${name}",
  "private": true,
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite --port 8787 --host 127.0.0.1",
    "build": "vite build",
    "preview": "vite preview --port 8787 --host 127.0.0.1",
    "test": "node --test tests/smoke.test.mjs"
  },
  "devDependencies": { "vite": "^6.0.0" }
}
EOF
    cat > "$dest/vite.config.js" <<'EOF'
import { defineConfig } from "vite";
export default defineConfig({ server: { port: 8787 } });
EOF
    cat > "$dest/index.html" <<EOF
<!doctype html>
<html lang="tr">
  <head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>${name}</title></head>
  <body><div id="app"></div><script type="module" src="/src/main.js"></script></body>
</html>
EOF
    print -r -- "document.querySelector('#app').innerHTML = '<h1>${name}</h1><p>Vite · Khayal</p>';" > "$dest/src/main.js"
    write_netlify "dist" "npm run build"
    write_node_test
    ;;
  next|nextjs)
    kind="next"
    mkdir -p "$dest/app" "$dest/tests"
    cat > "$dest/package.json" <<EOF
{
  "name": "${name}",
  "private": true,
  "version": "1.0.0",
  "scripts": {
    "dev": "next dev -p 8787",
    "build": "next build",
    "start": "next start -p 8787",
    "test": "node --test tests/smoke.test.mjs"
  },
  "dependencies": {
    "next": "^15.0.0",
    "react": "^19.0.0",
    "react-dom": "^19.0.0"
  }
}
EOF
    cat > "$dest/next.config.mjs" <<'EOF'
/** @type {import("next").NextConfig} */
const nextConfig = {};
export default nextConfig;
EOF
    cat > "$dest/app/layout.js" <<'EOF'
export const metadata = { title: "Khayal" };
export default function RootLayout({ children }) {
  return (
    <html lang="tr"><body>{children}</body></html>
  );
}
EOF
    cat > "$dest/app/page.js" <<EOF
export default function Page() {
  return <main><h1>${name}</h1><p>Next.js · Khayal</p></main>;
}
EOF
    write_netlify ".next" "npm run build"
    write_node_test
    ;;
  *)
    rm -rf "$dest"
    khayal_err "şablon yok: $kind  (php | html | node | vite | next)"
    exit 1
    ;;
esac

write_ignore
"$SCRIPT_DIR/workdir.sh" set "$dest" >/dev/null
if git --version >/dev/null 2>&1; then
  git -C "$dest" init -b main >/dev/null
  if ! git -C "$dest" config user.email >/dev/null 2>&1; then
    git -C "$dest" \
      -c user.name="${GIT_AUTHOR_NAME:-Khayal}" \
      -c user.email="${GIT_AUTHOR_EMAIL:-khayal@localhost}" \
      add -A
    git -C "$dest" \
      -c user.name="${GIT_AUTHOR_NAME:-Khayal}" \
      -c user.email="${GIT_AUTHOR_EMAIL:-khayal@localhost}" \
      commit -m "ilk: $kind $name" >/dev/null
  else
    git -C "$dest" add -A
    git -C "$dest" commit -m "ilk: $kind $name" >/dev/null
  fi
fi

if (( silent == 0 )); then
  "$SCRIPT_DIR/bagimlilik.sh" || true
fi
khayal_ok "proje: $dest  ($kind)"
khayal_dim "kod: khayal kod $name"
khayal_dim "önizle: khayal onizle  ·  test: khayal testet  ·  GitHub: khayal git baglan"
if (( silent == 0 )); then
  open -a Cursor "$dest" 2>/dev/null || true
fi
