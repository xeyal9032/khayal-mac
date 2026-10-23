# Apps on this Mac

Open with `open -a "Exact Name"`. Names must match `/Applications`.

## Daily

| App | Open as |
|---|---|
| Cursor | `Cursor` |
| Google Chrome | `Google Chrome` |
| Safari | `Safari` |
| ChatGPT | `ChatGPT` |
| Telegram | `Telegram` |
| WhatsApp | `WhatsApp` |
| Finder | `open -a Finder` or `open /path` |

## Dev

| App | Open as | Notes |
|---|---|---|
| Xcode | `Xcode` | LifeOS / KhayalAssistant |
| Docker | `Docker` | wait for engine: `docker info` |
| FileZilla Pro | `FileZilla Pro` | FTP/SFTP |
| Codex | `Codex` | |
| Developer | `Developer` | Apple Developer |

## Apple

Keynote, Numbers, Pages, GarageBand, iMovie, TestFlight.

## Other

AdBlock Pro, Antigravity, ChatGPT Atlas, ChatGPT Classic, RDesktop, Swiftify for Xcode.

## Quit

```bash
osascript -e 'tell application "Google Chrome" to quit'
```

Do not quit Cursor, Terminal, or an app that has unsaved work unless the user named it.
