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
  printf '\033]0;Khayal v%s — Mac ajanı\007' "$(khayal_version)"
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

khayal_banner() {
  local hello facts ver
  hello="$(khayal_hello)"
  facts="${1:-}"
  ver="$(khayal_version)"
  print -- ""
  print -- "  ${KH_MG}╭──────────────────────────────────────────────────╮${KH_RST}"
  print -- "  ${KH_MG}│${KH_RST}  ${KH_CY}${KH_B}KHAYAL${KH_RST}  ${KH_DIM}macOS operator${KH_RST}                 ${KH_YL}v${ver}${KH_RST}  ${KH_MG}│${KH_RST}"
  print -- "  ${KH_MG}│${KH_RST}  ${KH_WH}${hello}${KH_RST} ${KH_B}Khayal${KH_RST}                                   ${KH_MG}│${KH_RST}"
  if [[ -n "$facts" ]]; then
    print -- "  ${KH_MG}│${KH_RST}  ${KH_BL}${facts}${KH_RST}"
  fi
  print -- "  ${KH_MG}╰──────────────────────────────────────────────────╯${KH_RST}"
  print -- "  ${KH_DIM}menu  ·  doctor  ·  help  ·  cikis${KH_RST}"
  print -- ""
}

khayal_greet_line() {
  print -- "${KH_MG}◆${KH_RST} ${KH_CY}${KH_B}Khayal${KH_RST} ${KH_DIM}v$(khayal_version) hazır${KH_RST}  ${KH_DIM}·${KH_RST}  ${KH_YL}khayal${KH_RST} ${KH_DIM}yaz${KH_RST}"
}

khayal_menu() {
  print -- ""
  print -- "  ${KH_CY}${KH_B}komut paleti${KH_RST}"
  khayal_hr
  print -- "  ${KH_YL}1${KH_RST}  durum          ${KH_DIM}pil · disk · ağ${KH_RST}"
  print -- "  ${KH_YL}2${KH_RST}  günaydın       ${KH_DIM}takvim + hava${KH_RST}"
  print -- "  ${KH_YL}3${KH_RST}  doctor         ${KH_DIM}ajan sağlığı${KH_RST}"
  print -- "  ${KH_YL}4${KH_RST}  yan yana       ${KH_DIM}Chrome + Cursor${KH_RST}"
  print -- "  ${KH_YL}5${KH_RST}  düzenle        ${KH_DIM}Downloads${KH_RST}"
  print -- "  ${KH_YL}6${KH_RST}  pano           ${KH_DIM}yapıştırma geçmişi${KH_RST}"
  print -- "  ${KH_YL}7${KH_RST}  git durum      ${KH_DIM}repo${KH_RST}"
  print -- "  ${KH_YL}8${KH_RST}  yayın          ${KH_DIM}Netlify${KH_RST}"
  print -- "  ${KH_YL}9${KH_RST}  demo           ${KH_DIM}wow turu${KH_RST}"
  print -- "  ${KH_YL}0${KH_RST}  help           ${KH_DIM}tam liste${KH_RST}"
  print -- ""
  khayal_dim "yaz: 3   veya   khayal doctor"
  print -- ""
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
  khayal_key "khayal kod <proje>" "klasör seç, dosya yaz"
  khayal_key "khayal git kaydet" "init · baglan · gonder"
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
