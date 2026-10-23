#!/bin/zsh
# Color + banner helpers. Source this file; do not exec.

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  KH_RST=$'\033[0m'
  KH_B=$'\033[1m'
  KH_DIM=$'\033[2m'
  KH_CY=$'\033[38;2;103;232;249m'
  KH_MG=$'\033[38;2;232;121;249m'
  KH_YL=$'\033[38;2;250;204;21m'
  KH_GN=$'\033[38;2;74;222;128m'
  KH_BL=$'\033[38;2;96;165;250m'
  KH_OR=$'\033[38;2;251;146;60m'
  KH_RD=$'\033[38;2;248;113;113m'
  KH_WH=$'\033[38;2;248;250;252m'
else
  KH_RST="" KH_B="" KH_DIM="" KH_CY="" KH_MG="" KH_YL=""
  KH_GN="" KH_BL="" KH_OR="" KH_RD="" KH_WH=""
fi

khayal_version() {
  local f="${KHAYAL_ROOT:-$HOME/.cursor/skills/khayal-mac}/VERSION"
  if [[ -s "$f" ]]; then
    tr -d '[:space:]' < "$f"
  else
    print -- "1.2.0"
  fi
}

khayal_hello() {
  local h
  h="$(date +%H)"
  if (( h < 6 )); then print -- "İyi geceler"
  elif (( h < 12 )); then print -- "Günaydın"
  elif (( h < 18 )); then print -- "İyi günler"
  else print -- "İyi akşamlar"
  fi
}

khayal_ok()  { print -- "  ${KH_GN}✔${KH_RST}  $*"; }
khayal_err() { print -- "  ${KH_RD}✖${KH_RST}  $*" >&2; }
khayal_dim() { print -- "  ${KH_DIM}$*${KH_RST}"; }
khayal_key() { print -- "  ${KH_CY}${(r:22:: :)1}${KH_RST} ${KH_DIM}$2${KH_RST}"; }
khayal_warn() { print -- "  ${KH_YL}●${KH_RST}  $*"; }

khayal_title() {
  [[ -e /dev/tty ]] || return 0
  printf '\033]0;Khayal v%s\007' "$(khayal_version)" >/dev/tty 2>/dev/null || true
}

khayal_bar() {
  local pct="${1%%%}" width="${2:-14}" fill i s=""
  if [[ "$pct" != <-> ]]; then
    print -n -- "??????????????"
    return 0
  fi
  fill=$(( pct * width / 100 ))
  if (( fill > width )); then fill=$width; fi
  if (( fill < 0 )); then fill=0; fi
  for (( i=1; i<=width; i++ )); do
    if (( i <= fill )); then s+="█"; else s+="░"; fi
  done
  print -n -- "$s"
}

khayal_hr() {
  print -- "  ${KH_DIM}──────────────────────────────────────────────${KH_RST}"
}

khayal_chime() {
  [[ -n "${KHAYAL_NOSOUND:-}" ]] && return 0
  [[ -t 1 ]] || return 0
  afplay /System/Library/Sounds/Tink.aiff >/dev/null 2>&1 &
}

khayal_vislen() {
  local s
  s="$(print -r -- "$1" | sed $'s/\x1b\\[[0-9;]*m//g')"
  print -r -- ${#s}
}

khayal_box_line() {
  local body="$1"
  local vis pad inner=50 spacer=""
  vis="$(print -r -- "$body" | sed $'s/\x1b\\[[0-9;]*m//g')"
  pad=$(( inner - ${#vis} ))
  if (( pad < 0 )); then pad=0; fi
  spacer="$(printf '%*s' "$pad" '')"
  print -- "  ${KH_MG}│${KH_RST}${body}${spacer}${KH_MG}│${KH_RST}"
}

khayal_banner() {
  local hello facts ver bar
  hello="$(khayal_hello)"
  facts="${1:-}"
  ver="$(khayal_version)"
  bar="$(printf '%.0s─' {1..50})"
  print -- "  ${KH_MG}╭${bar}╮${KH_RST}"
  khayal_box_line "  ${KH_CY}${KH_B}KHAYAL${KH_RST}  ${KH_DIM}macOS operator${KH_RST}                 ${KH_YL}v${ver}${KH_RST}"
  khayal_box_line "  ${KH_WH}${hello}${KH_RST} ${KH_B}Khayal${KH_RST}"
  if [[ -n "$facts" ]]; then
    khayal_box_line "  ${KH_BL}${facts}${KH_RST}"
  fi
  print -- "  ${KH_MG}╰${bar}╯${KH_RST}"
  print -- "  ${KH_DIM}menu  ·  doctor  ·  help  ·  cikis${KH_RST}"
}

khayal_greet_line() {
  print -- "${KH_MG}◆${KH_RST} ${KH_CY}${KH_B}Khayal${KH_RST} ${KH_DIM}v$(khayal_version) hazır${KH_RST}  ${KH_DIM}·${KH_RST}  ${KH_YL}khayal${KH_RST} ${KH_DIM}yaz${KH_RST}"
}

khayal_menu_init() {
  [[ -n "${KHAYAL_MENU_READY:-}" ]] && return 0
  typeset -gA KHAYAL_MENU_CMD KHAYAL_MENU_DESC
  typeset -ga KHAYAL_MENU_ORDER
  khayal_menu_add() {
    KHAYAL_MENU_CMD[$1]="$2"
    KHAYAL_MENU_DESC[$1]="$3"
    KHAYAL_MENU_ORDER+=("$1")
  }
  khayal_menu_add 1  "durum"                 "pil · disk · ağ · ses"
  khayal_menu_add 2  "gunaydin"              "takvim + hava + pil"
  khayal_menu_add 3  "yarin"                 "yarın özeti"
  khayal_menu_add 4  "yan yana"              "Chrome sol · Cursor sağ"
  khayal_menu_add 5  "duzenle"               "Downloads klasörle"
  khayal_menu_add 6  "finder"                "Finder aç"
  khayal_menu_add 7  "chrome"                "Google Chrome"
  khayal_menu_add 8  "karanlik"              "karanlık mod"
  khayal_menu_add 9  "aydinlik"              "aydınlık mod"
  khayal_menu_add 10 "ss"                    "ekran görüntüsü"
  khayal_menu_add 11 "ss pdf"                "ekran → PDF"
  khayal_menu_add 12 "kilitle"               "ekranı kilitle"
  khayal_menu_add 13 "saglik"                "Mac sağlık"
  khayal_menu_add 14 "sistir"                "ağır süreçler"
  khayal_menu_add 15 "toparla"               "temizlik planı"
  khayal_menu_add 16 "uyku"                  "uyku rutini"
  khayal_menu_add 17 "pano"                  "pano geçmişi"
  khayal_menu_add 18 "yapistir 1"            "son panoyu yapıştır"
  khayal_menu_add 19 "ayar wifi"             "Wi-Fi paneli"
  khayal_menu_add 20 "spotlight"             "Spotlight Khayal"
  khayal_menu_add 21 "yeni"                  "proje şablonları"
  khayal_menu_add 22 "onizle"                "localhost:8787"
  khayal_menu_add 23 "paketler"              "npm / composer"
  khayal_menu_add 24 "testet"                "proje testleri"
  khayal_menu_add 25 "bak"                   "yazılan kodu göster"
  khayal_menu_add 26 "diff"                  "git diff"
  khayal_menu_add 27 "git durum"             "repo durumu"
  khayal_menu_add 28 "git baglan"            "GitHub repo"
  khayal_menu_add 29 "yayin"                 "Netlify durum"
  khayal_menu_add 30 "kod"                   "çalışma klasörü"
  khayal_menu_add 31 "php"                   "yeniphpfile aç"
  khayal_menu_add 32 "docker ps"             "konteynerler"
  khayal_menu_add 33 "doctor"                "ajan sağlığı"
  khayal_menu_add 34 "demo"                  "wow turu"
  khayal_menu_add 35 "guncelle"              "GitHub'dan güncelle"
  khayal_menu_add 36 "paketle"               "başka Mac zip"
  khayal_menu_add 37 "e2e"                   "ajan testleri"
  khayal_menu_add 38 "versiyon"              "sürüm"
  khayal_menu_add 39 "github"                "repo'yu aç"
  khayal_menu_add 40 "help"                  "tam liste"
  KHAYAL_MENU_READY=1
}

khayal_menu() {
  khayal_menu_init
  print -- ""
  print -- "  ${KH_CY}${KH_B}komut paleti${KH_RST}  ${KH_DIM}kısayol kodları${KH_RST}"
  khayal_hr
  print -- "  ${KH_MG}Mac${KH_RST}"
  local id cmdp
  for id in {1..20}; do
    cmdp="khayal ${KHAYAL_MENU_CMD[$id]}"
    print -- "  ${KH_YL}${(l:2:: :)id}${KH_RST}  ${KH_CY}${(r:22:: :)cmdp}${KH_RST} ${KH_DIM}${KHAYAL_MENU_DESC[$id]}${KH_RST}"
  done
  print -- ""
  print -- "  ${KH_MG}Kod${KH_RST}"
  for id in {21..32}; do
    cmdp="khayal ${KHAYAL_MENU_CMD[$id]}"
    print -- "  ${KH_YL}${(l:2:: :)id}${KH_RST}  ${KH_CY}${(r:22:: :)cmdp}${KH_RST} ${KH_DIM}${KHAYAL_MENU_DESC[$id]}${KH_RST}"
  done
  print -- ""
  print -- "  ${KH_MG}Ajan${KH_RST}"
  for id in {33..40}; do
    cmdp="khayal ${KHAYAL_MENU_CMD[$id]}"
    print -- "  ${KH_YL}${(l:2:: :)id}${KH_RST}  ${KH_CY}${(r:22:: :)cmdp}${KH_RST} ${KH_DIM}${KHAYAL_MENU_DESC[$id]}${KH_RST}"
  done
  print -- ""
  khayal_dim "REPL'de numara yaz:  33  →  doctor"
  print -- ""
}

khayal_menu_lookup() {
  khayal_menu_init
  print -r -- "${KHAYAL_MENU_CMD[$1]:-}"
}

khayal_usage() {
  local ver
  ver="$(khayal_version)"
  print -- ""
  print -- "  ${KH_CY}${KH_B}Khayal Mac${KH_RST}  ${KH_DIM}v${ver} · bu MacBook'un ajanı${KH_RST}"
  print -- ""
  print -- "  ${KH_MG}Mac${KH_RST}"
  khayal_key "khayal durum" "pil · disk · wifi · ses"
  khayal_key "khayal finderı ac" "Chrome, Telegram, Docker"
  khayal_key "khayal ayar wifi" "Sistem Ayarları"
  khayal_key "khayal yan yana" "Chrome sol · Cursor sağ"
  khayal_key "khayal gunaydin" "takvim + hava + pil"
  print -- ""
  print -- "  ${KH_MG}Kod${KH_RST}"
  khayal_key "khayal yeni php ad" "php html node vite next"
  khayal_key "khayal clone <url>" "GitHub'dan indir"
  khayal_key "khayal paketler" "npm / composer install"
  khayal_key "khayal testet" "proje testleri"
  khayal_key "khayal onizle" "localhost:8787"
  khayal_key "khayal bak" "az önce yazılan kod"
  khayal_key "khayal bak index.html" "dosyayı terminalde göster"
  khayal_key "khayal kod <proje>" "klasör seç, dosya yaz"
  khayal_key "khayal git baglan" "GitHub repo"
  khayal_key "khayal yayin yap evet" "Netlify canlı"
  print -- ""
  print -- "  ${KH_MG}Ajan${KH_RST}"
  khayal_key "khayal doctor" "sağlık taraması"
  khayal_key "khayal demo" "wow turu"
  khayal_key "khayal guncelle" "GitHub'dan güncelle"
  khayal_key "khayal paketle" "başka Mac için zip"
  khayal_key "khayal menu" "komut paleti"
  print -- ""
  print -- "  ${KH_YL}Cümle yeter${KH_RST}  ${KH_DIM}khayal Downloads klasörünü aç${KH_RST}"
  print -- ""
}
