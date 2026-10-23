#!/bin/zsh
set -euo pipefail

normalize() {
  print -r -- "${1:-}" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -e 's/ı/i/g' -e 's/İ/i/g' -e 's/ğ/g/g' -e 's/ü/u/g' -e 's/ş/s/g' -e 's/ö/o/g' -e 's/ç/c/g' \
    | sed -e "s/['’]//g" -e 's/[^a-z0-9 -]/ /g' -e 's/  */ /g' -e 's/^ //' -e 's/ $//'
}

wifi_dev() {
  networksetup -listallhardwareports 2>/dev/null \
    | awk '/Wi-Fi|AirPort/{getline; print $2; exit}'
}

open_url() {
  open "$1"
  print -- "ayar: $2"
}

open_app() {
  open -a "$1"
  print -- "ayar: $1"
}

usage_list() {
  cat <<'EOF'
Sistem Ayarları panelleri — khayal ayar <ad>

  wifi bluetooth ag pil ekran ses gorunum duvar dock kontrol
  bildirim odak ekran-suresi kilit-ekrani ekran-koruyucu touchid
  kullanicilar hesaplar icloud klavye trackpad fare yazici
  airdrop paylasim gizlilik erisilebilirlik dil tarih giris
  siri spotlight guncelleme timemachine depolama

Hızlı değiştir (panel açmadan):
  khayal ayar wifi ac|kapat
  khayal ayar dock gizle|goster
  khayal ayar gizli ac|kapat
  khayal karanlik mod
EOF
}

# args joined
raw="$(normalize "$*")"
if [[ -z "$raw" ]]; then
  open_app "System Settings"
  exit 0
fi

if [[ "$raw" == "list" || "$raw" == "liste" || "$raw" == "neler" ]]; then
  usage_list
  exit 0
fi

# --- power / toggle actions first ---
case "$raw" in
  "wifi ac"|"wifi on"|"wifi acik")
    dev="$(wifi_dev)"
    [[ -n "$dev" ]] || { print -- "Wi-Fi arayuzu bulunamadi" >&2; exit 1; }
    networksetup -setairportpower "$dev" on
    print -- "Wi-Fi acildi ($dev)"
    exit 0
    ;;
  "wifi kapat"|"wifi off"|"wifi kapali")
    dev="$(wifi_dev)"
    [[ -n "$dev" ]] || { print -- "Wi-Fi arayuzu bulunamadi" >&2; exit 1; }
    networksetup -setairportpower "$dev" off
    print -- "Wi-Fi kapatildi ($dev)"
    exit 0
    ;;
  "wifi durum"|"wifi")
    if [[ "$raw" == "wifi durum" ]]; then
      dev="$(wifi_dev)"
      networksetup -getairportpower "${dev:-en0}"
      ipconfig getifaddr "${dev:-en0}" 2>/dev/null || true
      exit 0
    fi
    ;;
  "dock gizle"|"dock autohide"|"dock sakla")
    defaults write com.apple.dock autohide -bool true
    killall Dock 2>/dev/null || true
    print -- "Dock otomatik gizle: acik"
    exit 0
    ;;
  "dock goster"|"dock show"|"dock ac")
    defaults write com.apple.dock autohide -bool false
    killall Dock 2>/dev/null || true
    print -- "Dock otomatik gizle: kapali"
    exit 0
    ;;
  "gizli ac"|"gizli dosyalar"|"gizli dosyalari goster"|"hidden on")
    defaults write com.apple.finder AppleShowAllFiles -bool true
    killall Finder 2>/dev/null || true
    print -- "Gizli dosyalar gorunuyor"
    exit 0
    ;;
  "gizli kapat"|"gizli dosyalari gizle"|"hidden off")
    defaults write com.apple.finder AppleShowAllFiles -bool false
    killall Finder 2>/dev/null || true
    print -- "Gizli dosyalar gizlendi"
    exit 0
    ;;
  "uzanti ac"|"uzantilar"|"extensions on")
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    killall Finder 2>/dev/null || true
    print -- "Dosya uzantilari gorunuyor"
    exit 0
    ;;
  "uzanti kapat"|"extensions off")
    defaults write NSGlobalDomain AppleShowAllExtensions -bool false
    killall Finder 2>/dev/null || true
    print -- "Dosya uzantilari gizlendi"
    exit 0
    ;;
  "yol cubugu"|"path bar")
    defaults write com.apple.finder ShowPathbar -bool true
    killall Finder 2>/dev/null || true
    print -- "Finder yol cubugu acik"
    exit 0
    ;;
  "tap click"|"dokunarak tikla"|"tap to click")
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    print -- "Trackpad dokunarak tikla acik (yeni oturumda kesinlesir)"
    exit 0
    ;;
  "dogal kaydirma"|"natural scroll")
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
    print -- "Dogal kaydirma acik"
    exit 0
    ;;
  "dogal kaydirma kapat"|"natural scroll off")
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
    print -- "Dogal kaydirma kapali"
    exit 0
    ;;
  "ekrani uyut"|"display sleep")
    pmset displaysleepnow
    print -- "Ekran uyutuldu"
    exit 0
    ;;
esac

# first token = pane
pane="${raw%% *}"

case "$pane" in
  wifi|wi-fi) open_url "x-apple.systempreferences:com.apple.WiFi-Settings.extension" "Wi-Fi" ;;
  bluetooth|blue) open_url "x-apple.systempreferences:com.apple.BluetoothSettings" "Bluetooth" ;;
  ag|network|internet) open_url "x-apple.systempreferences:com.apple.Network-Settings.extension" "Ag" ;;
  pil|battery) open_url "x-apple.systempreferences:com.apple.Battery-Settings.extension" "Pil" ;;
  ekran|ekranlar|display|displays) open_url "x-apple.systempreferences:com.apple.Displays-Settings.extension" "Ekranlar" ;;
  ses|sound|audio) open_url "x-apple.systempreferences:com.apple.Sound-Settings.extension" "Ses" ;;
  gorunum|appearance) open_url "x-apple.systempreferences:com.apple.Appearance-Settings.extension" "Gorunum" ;;
  duvar|wallpaper|duvar-kagidi) open_url "x-apple.systempreferences:com.apple.Wallpaper-Settings.extension" "Duvar kagidi" ;;
  dock|masaüstü|masaustu-dock) open_url "x-apple.systempreferences:com.apple.Desktop-Settings.extension" "Masaustu ve Dock" ;;
  kontrol|controlcenter|control) open_url "x-apple.systempreferences:com.apple.ControlCenter-Settings.extension" "Kontrol Merkezi" ;;
  bildirim|bildirimler|notifications) open_url "x-apple.systempreferences:com.apple.Notifications-Settings.extension" "Bildirimler" ;;
  odak|focus|dnd) open_url "x-apple.systempreferences:com.apple.Focus-Settings.extension" "Odak" ;;
  ekran-suresi|screentime) open_url "x-apple.systempreferences:com.apple.Screen-Time-Settings.extension" "Ekran suresi" ;;
  kilit-ekrani|lockscreen) open_url "x-apple.systempreferences:com.apple.Lock-Screen-Settings.extension" "Kilit ekrani" ;;
  ekran-koruyucu|screensaver) open_url "x-apple.systempreferences:com.apple.ScreenSaver-Settings.extension" "Ekran koruyucu" ;;
  touchid|touch-id) open_url "x-apple.systempreferences:com.apple.Touch-ID-Settings.extension" "Touch ID" ;;
  kullanicilar|users) open_url "x-apple.systempreferences:com.apple.Users-Groups-Settings.extension" "Kullanicilar" ;;
  hesaplar|accounts) open_url "x-apple.systempreferences:com.apple.Internet-Accounts-Settings.extension" "Internet hesaplari" ;;
  icloud)
    open_url "x-apple.systempreferences:com.apple.Settings.AppleID" "iCloud / Apple ID (sadece acilir)"
    ;;
  klavye|keyboard) open_url "x-apple.systempreferences:com.apple.Keyboard-Settings.extension" "Klavye" ;;
  trackpad|dokunmatik) open_url "x-apple.systempreferences:com.apple.Trackpad-Settings.extension" "Trackpad" ;;
  fare|mouse) open_url "x-apple.systempreferences:com.apple.Mouse-Settings.extension" "Fare" ;;
  yazici|printer|yazicilar) open_url "x-apple.systempreferences:com.apple.Print-Scan-Settings.extension" "Yazicilar" ;;
  airdrop|handoff) open_url "x-apple.systempreferences:com.apple.AirDrop-Handoff-Settings.extension" "AirDrop" ;;
  paylasim|sharing) open_url "x-apple.systempreferences:com.apple.Sharing-Settings.extension" "Paylasim" ;;
  gizlilik|guvenlik|security|privacy)
    open_url "x-apple.systempreferences:com.apple.preference.security" "Gizlilik ve Guvenlik"
    ;;
  erisilebilirlik|accessibility)
    open_url "x-apple.systempreferences:com.apple.Accessibility-Settings.extension" "Erisilebilirlik"
    ;;
  dil|language|bolge) open_url "x-apple.systempreferences:com.apple.Localization-Settings.extension" "Dil ve bolge" ;;
  tarih|saat|datetime) open_url "x-apple.systempreferences:com.apple.Date-Time-Settings.extension" "Tarih ve saat" ;;
  giris|loginitems|baslangic)
    open_url "x-apple.systempreferences:com.apple.LoginItems-Settings.extension" "Giris ogeleri"
    ;;
  siri) open_url "x-apple.systempreferences:com.apple.Siri-Settings.extension" "Siri" ;;
  spotlight)
    open "/System/Library/PreferencePanes/Spotlight.prefPane" 2>/dev/null \
      || open_url "x-apple.systempreferences:com.apple.Siri-Settings.extension" "Spotlight / Siri"
    print -- "ayar: Spotlight"
    ;;
  guncelleme|update|software)
    open_url "x-apple.systempreferences:com.apple.Software-Update-Settings.extension" "Yazilim guncelleme"
    ;;
  timemachine|zaman|yedek)
    open_url "x-apple.systempreferences:com.apple.Time-Machine-Settings.extension" "Time Machine"
    ;;
  depolama|storage)
    open_url "x-apple.systempreferences:com.apple.LocalStorage-Settings.extension" "Depolama"
    ;;
  sifirla|reset)
    print -- "Sifirlama panelini aciyorum; icerigi silmem."
    open_url "x-apple.systempreferences:com.apple.Transfer-Reset-Settings.extension" "Transfer / sifirla"
    ;;
  ayarlar|settings|sistem)
    open_app "System Settings"
    ;;
  *)
    open_app "System Settings"
    print -- "Bilinmeyen panel: $raw — Sistem Ayarlari acildi. Sol listeden sec."
    ;;
esac
