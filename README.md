<div align="center">

<img src="docs/banner.svg" alt="Khayal Mac — kişisel Mac operatörü" width="100%" />

<br/>

[![macOS](https://img.shields.io/badge/macOS-Apple%20Silicon-000000?style=for-the-badge&logo=apple&logoColor=white)](https://github.com/xeyal9032/khayal-mac)
[![zsh](https://img.shields.io/badge/CLI-khayal-67e8f9?style=for-the-badge&logo=gnubash&logoColor=0b1220)](https://github.com/xeyal9032/khayal-mac)
[![Cursor](https://img.shields.io/badge/Cursor-Agent-e879f9?style=for-the-badge)](https://cursor.com)
[![Release](https://img.shields.io/github/v/release/xeyal9032/khayal-mac?style=for-the-badge&color=22c55e&label=ZIP)](https://github.com/xeyal9032/khayal-mac/releases/latest)
[![E2E](https://img.shields.io/badge/E2E-70%20PASS-22c55e?style=for-the-badge)](tests/e2e.zsh)

**Khayal Mac** — bu MacBook’un kişisel ajanı.  
Finder, Sistem Ayarları, git, dosya yazma ve Netlify canlı yayın. Konuştuğun dilde cevap verir.

[Kurulum](#-kurulum) · [Zip indir](https://github.com/xeyal9032/khayal-mac/releases/latest) · [Komutlar](#-komutlar) · [Güvenlik](#-güvenlik)

</div>

---

## Kartlar

<table>
<tr>
<td width="33%" valign="top">

### Mac kontrol
Finder, Chrome, Wi-Fi, Dock, karanlık mod, kilit, ekran görüntüsü, pencere düzeni. Sistem Ayarları panellerinin tamamı.

`khayal finderı aç`  
`khayal ayar wifi`

</td>
<td width="33%" valign="top">

### Kod ve git
Klasör seç, dosya yaz, `git init` / remote / commit / push. GitHub bağlantısı. Xcode lisansı bir kez.

`khayal kod yeniphpfile`  
`khayal git kaydet`

</td>
<td width="33%" valign="top">

### Canlı yayın
Netlify production deploy — sadece sen `evet` deyince. Docker konteyner listesi.

`khayal yayin`  
`khayal yayin yap evet`

</td>
</tr>
<tr>
<td width="33%" valign="top">

### Günlük rutin
Sabah özeti, yarın bildirimi, hatırlatma, Downloads klasörleme, temizlik planı, sağlık, şişen süreçler.

`khayal gunaydin`  
`khayal toparla`

</td>
<td width="33%" valign="top">

### Pano ve taslak
Pano geçmişi, Telegram/WhatsApp **taslak** (asla göndermez), Spotlight uygulaması, ⌥Space kısayolu.

`khayal pano`  
`khayal taslak telegram ...`

</td>
<td width="33%" valign="top">

### Başka Mac
Tek komutla zip al, diğer Mac’te tek komutla kur. Skill, zsh, Spotlight ve arka plan görevleri yerleşir.

`khayal paketle`  
`khayal kur`

</td>
</tr>
</table>

---

## Kurulum

<table>
<tr>
<td width="50%" valign="top">

### Kart 1 — Git clone (önerilen)

Yeni Mac’te Terminal:

```bash
git clone https://github.com/xeyal9032/khayal-mac.git \
  ~/.cursor/skills/khayal-mac

zsh ~/.cursor/skills/khayal-mac/scripts/install.sh
```

Yeni bir Terminal aç, sonra:

```bash
khayal help
```

</td>
<td width="50%" valign="top">

### Kart 2 — Zip ile kur

1. [Son sürümü indir](https://github.com/xeyal9032/khayal-mac/releases/latest) — `Khayal-Mac-Ajan.zip`
2. Terminal:

```bash
unzip ~/Downloads/Khayal-Mac-Ajan.zip -d /tmp
zsh /tmp/khayal-mac/scripts/install.sh
```

Bu Mac’ten zip üretmek:

```bash
khayal paketle
```

Masaüstüne `Khayal-Mac-Ajan.zip` yazar. AirDrop / USB yeter.

</td>
</tr>
</table>

### İlk açılış (bir kez)

| Adım | Komut / yer |
|---|---|
| 1. Cursor CLI | `curl https://cursor.com/install -fsS \| bash` |
| 2. Giriş | `agent login` |
| 3. İzinler | Sistem Ayarları → Gizlilik → **Erişilebilirlik** / **Otomasyon** |
| 4. Git (gerekirse) | `sudo xcodebuild -license accept` |

Kurulum skill’i `~/.cursor/skills/khayal-mac` altına koyar, `~/.zshrc` içine `khayal` komutunu ekler, Spotlight uygulamasını ve pano/sağlık daemons’larını yükler.

Aynı Mac’i yeniden kurmak: `khayal kur`

---

## Komutlar

| Komut | Ne yapar |
|---|---|
| `khayal` | Renkli sohbet (REPL) |
| `khayal durum` | Pil · disk · Wi-Fi · ses |
| `khayal gunaydin` | Takvim + hava + pil |
| `khayal yan yana` | Chrome sol, Cursor sağ |
| `khayal duzenle` | Downloads’ı klasörle |
| `khayal kod <proje>` | Çalışma klasörü + dosya yaz |
| `khayal git durum\|init\|baglan\|kaydet\|gonder` | Git |
| `khayal yayin yap evet` | Netlify production |
| `khayal paketle` | Başka Mac için zip |
| `khayal kur` | Bu Mac’e ajanı kur |
| `khayal e2e` | Test paketi |
| `khayal help` | Tam liste |

Cümle de olur: `khayal Downloads klasörünü aç` — ajan yapar.

---

## Güvenlik

Onaysız **yapılmaz:** çöpü boşaltmak, Mac’i uyutmak, `rm -rf`, production Netlify, Telegram/WhatsApp **göndermek** (yalnızca taslak), `git config`, `git push --force`, `.env` / SSH anahtarı okumak.

`toparla evet` temizliği onaylar. `yayin yap evet` canlıya almayı onaylar.

---

## Test

```bash
khayal e2e
```

Kontrol edilen yollar (syntax, CLI, git sandbox, pano, ajanla PHP yazma, kurulum/paketleme) yeşil geçer. Çöp silme, Mac uyutma ve canlı Netlify testte kasıtlı atlanır.

---

<div align="center">

### Khayal · xeyal9032

[![GitHub](https://img.shields.io/badge/GitHub-xeyal9032-181717?style=for-the-badge&logo=github)](https://github.com/xeyal9032)
[![Web](https://img.shields.io/badge/OstWind-frontend.ostwind.az-67e8f9?style=for-the-badge)](https://frontend.ostwind.az/)

<img src="https://github-readme-stats.vercel.app/api?username=xeyal9032&show_icons=true&theme=tokyonight&hide_border=true&bg_color=0b1220&title_color=67e8f9&icon_color=e879f9&text_color=e2e8f0" alt="GitHub stats" />
<img src="https://github-readme-stats.vercel.app/api/top-langs/?username=xeyal9032&layout=compact&theme=tokyonight&hide_border=true&bg_color=0b1220&title_color=e879f9&text_color=e2e8f0" alt="Top languages" />

<br/>

<sub>Kişisel ajan · Khayal Jamilli · macOS</sub>

</div>
