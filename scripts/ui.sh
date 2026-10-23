#!/bin/zsh
# Color + banner helpers. Source this file; do not exec.

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  KH_RST=$'\033[0m'
  KH_B=$'\033[1m'
  KH_DIM=$'\033[2m'
  KH_CY=$'\033[38;5;51m'
  KH_MG=$'\033[38;5;213m'
  KH_YL=$'\033[38;5;221m'
  KH_GN=$'\033[38;5;114m'
  KH_BL=$'\033[38;5;75m'
  KH_OR=$'\033[38;5;215m'
  KH_RD=$'\033[38;5;203m'
  KH_WH=$'\033[38;5;255m'
else
  KH_RST="" KH_B="" KH_DIM="" KH_CY="" KH_MG="" KH_YL=""
  KH_GN="" KH_BL="" KH_OR="" KH_RD="" KH_WH=""
fi

khayal_hello() {
  local h
  h="$(date +%H)"
  if (( h < 6 )); then print -- "İyi geceler"
  elif (( h < 12 )); then print -- "Günaydın"
  elif (( h < 18 )); then print -- "İyi günler"
  else print -- "İyi akşamlar"
  fi
}

khayal_ok()  { print -- "${KH_GN}✔${KH_RST} $*"; }
khayal_err() { print -- "${KH_RD}✖${KH_RST} $*" >&2; }
khayal_dim() { print -- "${KH_DIM}$*${KH_RST}"; }
khayal_key() { print -- "  ${KH_CY}$1${KH_RST}  ${KH_DIM}$2${KH_RST}"; }

khayal_title() {
  printf '\033]0;Khayal — Mac ajanı\007'
}

khayal_banner() {
  local hello facts
  hello="$(khayal_hello)"
  facts="${1:-}"
  print -- ""
  print -- "  ${KH_MG}${KH_B}╭──────────────────────────────────────────────╮${KH_RST}"
  print -- "  ${KH_MG}${KH_B}│${KH_RST}  ${KH_CY}${KH_B}K H A Y A L${KH_RST}     ${KH_DIM}MacBook ajanı${KH_RST}           ${KH_MG}${KH_B}│${KH_RST}"
  print -- "  ${KH_MG}${KH_B}│${KH_RST}  ${KH_YL}${hello}${KH_RST} Khayal                              ${KH_MG}${KH_B}│${KH_RST}"
  if [[ -n "$facts" ]]; then
    print -- "  ${KH_MG}${KH_B}│${KH_RST}  ${KH_BL}${facts}${KH_RST}"
  fi
  print -- "  ${KH_MG}${KH_B}╰──────────────────────────────────────────────╯${KH_RST}"
  print -- "  ${KH_DIM}yaz ve enter  ·  help  ·  cikis${KH_RST}"
  print -- ""
}

khayal_greet_line() {
  print -- "${KH_MG}◆${KH_RST} ${KH_CY}${KH_B}Khayal${KH_RST} ${KH_DIM}hazır${KH_RST}  ${KH_DIM}·${KH_RST}  ${KH_YL}khayal${KH_RST} ${KH_DIM}yaz${KH_RST}"
}

khayal_usage() {
  print -- ""
  print -- "  ${KH_CY}${KH_B}Khayal Mac${KH_RST}  ${KH_DIM}bu MacBook'un ajanı${KH_RST}"
  print -- ""
  print -- "  ${KH_YL}Hızlı${KH_RST}"
  khayal_key "khayal" "sohbet (renkli ekran)"
  khayal_key "khayal durum" "pil · disk · wifi · ses"
  khayal_key "khayal finderı ac" "Chrome, Telegram, Docker..."
  khayal_key "khayal karanlik mod" "aydınlık / kilit / ses"
  khayal_key "khayal ayar wifi" "tum Sistem Ayarlari"
  khayal_key "khayal ayar list" "panel adlari"
  khayal_key "khayal gunaydin" "takvim + hava + pil"
  khayal_key "khayal yan yana" "Chrome sol, Cursor sag"
  khayal_key "khayal duzenle" "Downloads klasorle"
  khayal_key "khayal spotlight" "Cmd+Space kisayolu"
  khayal_key "khayal gunaydin / yarin" "bugun / yarin ozeti"
  khayal_key "khayal 20 dakikaya kahve" "Reminders"
  khayal_key "khayal yan yana / uyku / toparla" "duzen + bakim"
  khayal_key "khayal php / lifeos" "proje + git"
  khayal_key "khayal kod yeniphpfile" "klasör seç, dosya yaz"
  khayal_key "khayal git baglan" "GitHub remote"
  khayal_key "khayal yayin yap evet" "Netlify canlı"
  khayal_key "khayal model hizli" "az düşün (varsayılan)"
  khayal_key "khayal model guc" "daha derin model"
  khayal_key "khayal saglik / sistir / pano" "sistem"
  khayal_key "khayal paketle" "başka Mac için zip"
  khayal_key "khayal kur" "bu Mac'e ajanı kur"
  print -- ""
  print -- "  ${KH_YL}Cümle${KH_RST}  ${KH_DIM}ajan yapar${KH_RST}"
  khayal_key "khayal Downloads klasorunu ac" ""
  khayal_key "khayal 8080 kim dinliyor" ""
  print -- ""
}
