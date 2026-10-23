# All System Settings + Mac operations

If a CLI/script exists, **do it**. If only GUI exists, open the exact pane (`ayar.sh`) and finish with System Events clicks when Accessibility is granted. Never reply "Mac ayarlarını değiştiremem".

Open a pane:

```bash
~/.cursor/skills/khayal-mac/scripts/ayar.sh wifi
~/.cursor/skills/khayal-mac/scripts/ayar.sh list
```

## Panes (macOS 27)

| Turkish | `ayar.sh` key | URL / action |
|---|---|---|
| Sistem Ayarları | (empty) | `open -a "System Settings"` |
| Wi-Fi | `wifi` | `com.apple.WiFi-Settings.extension` |
| Bluetooth | `bluetooth` | `com.apple.BluetoothSettings` |
| Ağ | `ag` | `com.apple.Network-Settings.extension` |
| Pil | `pil` | `com.apple.Battery-Settings.extension` |
| Ekranlar | `ekran` | `com.apple.Displays-Settings.extension` |
| Ses | `ses` | `com.apple.Sound-Settings.extension` |
| Görünüm | `gorunum` | `com.apple.Appearance-Settings.extension` |
| Duvar kağıdı | `duvar` | `com.apple.Wallpaper-Settings.extension` |
| Masaüstü ve Dock | `dock` | `com.apple.Desktop-Settings.extension` |
| Kontrol Merkezi | `kontrol` | `com.apple.ControlCenter-Settings.extension` |
| Bildirimler | `bildirim` | `com.apple.Notifications-Settings.extension` |
| Odak | `odak` | `com.apple.Focus-Settings.extension` |
| Ekran süresi | `ekran-suresi` | `com.apple.Screen-Time-Settings.extension` |
| Kilit ekranı | `kilit-ekrani` | `com.apple.Lock-Screen-Settings.extension` |
| Ekran koruyucu | `ekran-koruyucu` | `com.apple.ScreenSaver-Settings.extension` |
| Dokunmatik ID | `touchid` | `com.apple.Touch-ID-Settings.extension` |
| Kullanıcılar | `kullanicilar` | `com.apple.Users-Groups-Settings.extension` |
| İnternet hesapları | `hesaplar` | `com.apple.Internet-Accounts-Settings.extension` |
| iCloud | `icloud` | open pane only — never sign out |
| Game Center | `gamecenter` | `com.apple.Game-Center-Settings.extension` |
| Cüzdan | `cuzdan` | open only — never pay |
| Klavye | `klavye` | `com.apple.Keyboard-Settings.extension` |
| Trackpad | `trackpad` | `com.apple.Trackpad-Settings.extension` |
| Fare | `fare` | `com.apple.Mouse-Settings.extension` |
| Yazıcılar | `yazici` | `com.apple.Print-Scan-Settings.extension` |
| AirDrop | `airdrop` | `com.apple.AirDrop-Handoff-Settings.extension` |
| Paylaşım | `paylasim` | `com.apple.Sharing-Settings.extension` |
| Gizlilik ve Güvenlik | `gizlilik` | `com.apple.preference.security` |
| Erişilebilirlik | `erisilebilirlik` | `com.apple.Accessibility-Settings.extension` |
| Dil ve bölge | `dil` | `com.apple.Localization-Settings.extension` |
| Tarih ve saat | `tarih` | `com.apple.Date-Time-Settings.extension` |
| Giriş öğeleri | `giris` | `com.apple.LoginItems-Settings.extension` |
| Siri | `siri` | `com.apple.Siri-Settings.extension` |
| Spotlight | `spotlight` | Spotlight pref pane / Siri search |
| Yazılım güncelleme | `guncelleme` | `com.apple.Software-Update-Settings.extension` |
| Time Machine | `timemachine` | `com.apple.Time-Machine-Settings.extension` |
| Depolama | `depolama` | `com.apple.Local-Storage-Settings.extension` |
| Transfer / sıfırla | `sifirla` | open only — never reset |
| Profiller | `profiller` | `com.apple.Profiles-Settings.extension` |

If a URL 404s: `open -a "System Settings"` and name the sidebar row in Turkish.

## Toggles the agent must perform (not just open)

See `ayar.sh` and [capabilities.md](capabilities.md): appearance, Dock autohide/size/magnification, Finder hidden files / extensions / path bar, screenshot location/type, volume/mute, Wi-Fi power, keyboard repeat, tap-to-click, natural scroll, battery %, Night Shift pane, display sleep (`pmset`), hostname (`scutil`, confirm), DNS flush (sudo, confirm), firewall pane, Gatekeeper pane, Time Machine status (`tmutil`), Spotlight index (`mdutil`, confirm), Launchpad reset, login items pane, default browser pane, AirDrop discoverability pane.

## Never

Apple ID sign-out, FileVault, firmware password, SIP (`csrutil`), Keychain, Passwords app, Apple Pay, Erase All Content, disabling Find My, MDM profiles delete, `sudo rm`.
