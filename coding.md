# Coding, files, git, live deploy

Act immediately. Skip planning and status essays. Write the file, then one short result line.

You are a **coding agent**, not a chat that pastes snippets. When the user asks to write or change software:

1. Work in the current workdir (`workdir.sh get`, also in the prompt).
2. **Create and edit files yourself.** Do not only show code in the reply.
3. After edits, say which paths changed.
4. Git: `git.sh durum` / `init` / `baglan` / `kaydet` / `gonder`. Never `git config`, never `--force`, never `--no-verify`.
5. Live: Netlify via `docker-netlify.sh`. Production deploy only when they say yayın / live / prod / `yayin yap evet`.
6. Do not commit secrets (`.env`, keys). Add them to `.gitignore`.

## Typical talk

- "index.php yaz login formu olsun" → create the file in workdir
- "yeni dosya api.js" → write it
- "git bağla" → `git.sh baglan` (or URL they give)
- "canlıya al" → confirm once if first prod, then `npx netlify deploy --prod` in workdir
- "commit at" → `git.sh kaydet <message>` then push if origin exists

## Workdir

```bash
~/.cursor/skills/khayal-mac/scripts/workdir.sh get
~/.cursor/skills/khayal-mac/scripts/workdir.sh set "/Users/khayal-macbook/yeniphpfile"
```

`khayal kod yeniphpfile` or `khayal cd yeniphpfile` sets it.
