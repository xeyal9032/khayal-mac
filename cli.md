# `khayal` terminal CLI

Binary: `~/.cursor/skills/khayal-mac/scripts/khayal`  
On PATH via `~/.local/bin/khayal` and a zsh function in `~/.zshrc`.

## Usage

```bash
khayal                     # renkli sohbet ekranı (REPL)
khayal tui                 # klasik Cursor Agent arayüzü
khayal finderı aç          # hızlı yol — AI yok
khayal "Downloads'ı düzenle, eski zip'leri çöpe at"   # Cursor agent
khayal -a "..."            # her zaman agent
khayal cd yeniphpfile      # zsh içinde klasöre gir
khayal proje lifeos        # Cursor'da projeyi aç
khayal durum               # pil, disk, wifi, ses
khayal ayar wifi           # Sistem Ayarları paneli
khayal ayar list           # tüm panel adları
khayal ayar wifi kapat     # Wi-Fi kapat
khayal gunaydin            # takvim + hava + pil
khayal yan yana            # Chrome sol, Cursor sağ
khayal duzenle             # Downloads klasörle
khayal downloads otomatik ac
khayal spotlight           # Spotlight uygulaması
khayal yarin               # yarın takvim + hava (20:00 bildirim)
khayal 20 dakikaya kahve   # Reminders
khayal taslak telegram merhaba
khayal pano / khayal yapistir 1
khayal toparla             # plan;  khayal toparla evet
khayal saglik / sistir
khayal kod yeniphpfile     # çalışma klasörü + sohbetle kod
khayal git durum|init|baglan [url]|kaydet|gonder
khayal php / lifeos
khayal docker ps / yayin
khayal ss pdf
khayal uyku                # rutin;  khayal uyu = Mac uyusun
khayal ses dinle           # 25 sn ses komutu
khayal pro kur             # kısayol + arka plan görevleri
khayal paketle             # başka Mac için zip (Masaüstü)
khayal kur                 # bu Mac'e ajanı kur (zip'ten sonra)
khayal login
khayal help
```

## Fast vs agent

Short, unambiguous Mac actions (open Finder/Chrome, dark mode, screenshot, status, lock, mute) run locally in milliseconds.

Anything else, or `-a` / `--agent`, runs:

```bash
agent -p --force --trust --sandbox disabled --output-format text "<prompt>"
```

cwd = `$HOME`. Prompt tells the agent to read `SKILL.md` and execute.

Interactive (no args):

```bash
agent --force --sandbox disabled
```

If `agent` is missing: `curl https://cursor.com/install -fsS | bash` then `agent login`.
