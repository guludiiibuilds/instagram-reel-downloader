---
name: instagram-reel-downloader
description: Downloads Instagram Reels (and other Instagram video posts) to a local file given their URL. Use this whenever the user shares an instagram.com/reel/... (or /p/..., /tv/...) link and asks to download, save, grab, or get a copy of it, even if they don't use the word "skill" or mention yt-dlp by name. Also use it if they ask how to download Instagram videos in general.
---

# Instagram Reel Downloader

Download an Instagram Reel (or other video post) to disk by shelling out to
`yt-dlp`. Instagram's internal page structure and API change often, so rather
than scraping Instagram directly, this skill relies on `yt-dlp`, which is
actively maintained to track those changes.

## Before downloading: check rights, not just reachability

Only download content the user has the right to save — their own posts,
content someone gave them permission to keep, or content under a license that
allows reuse. This skill is for personal archiving, not for redistributing or
republishing someone else's copyrighted content. If a request sounds like
bulk-scraping another account's content or redistributing creators' work
without permission, don't proceed — ask what it's for, or decline.

Downloading someone else's private or unlisted content, or bypassing
Instagram's access controls, is also out of scope even when technically
possible with cookies.

## How to run it

Use the bundled script rather than reimplementing the yt-dlp invocation:

```bash
.claude/skills/instagram-reel-downloader/scripts/download_reel.sh <instagram_url> [options]
```

Options:
- `-o, --output DIR` — where to save the file (defaults to the current directory)
- `-c, --cookies FILE` — a Netscape-format `cookies.txt` for content that needs a login
- `-b, --cookies-from-browser BROWSER` — read cookies straight from a local browser profile (`chrome`, `firefox`, `edge`, `brave`, `safari`, ...) instead of a file
- `-h, --help` — print usage

The script:
1. Validates the URL is actually an `instagram.com` link before doing anything else.
2. Checks that `yt-dlp` is installed and gives install instructions (`pip install -U yt-dlp`, `pipx install yt-dlp`, or `brew install yt-dlp`) if it isn't.
3. Runs `yt-dlp` with a filename template like `Uploader - Title [id].ext` in the chosen output directory.

## Typical usage

Public reel, save to the current directory:
```bash
.claude/skills/instagram-reel-downloader/scripts/download_reel.sh https://www.instagram.com/reel/Cxxxxxxxxxx/
```

Save into a specific folder:
```bash
.claude/skills/instagram-reel-downloader/scripts/download_reel.sh https://www.instagram.com/reel/Cxxxxxxxxxx/ -o ~/Downloads/reels
```

Content that requires being logged in (the user's own private account, an
age-gated post, or a case where Instagram is rate-limiting anonymous
requests) — ask the user to export their own Instagram cookies (e.g. with a
browser extension like "Get cookies.txt") rather than asking for their
password, then pass the file:
```bash
.claude/skills/instagram-reel-downloader/scripts/download_reel.sh https://www.instagram.com/reel/Cxxxxxxxxxx/ -c cookies.txt
```

Or pull cookies straight from a browser the user is already logged into:
```bash
.claude/skills/instagram-reel-downloader/scripts/download_reel.sh https://www.instagram.com/reel/Cxxxxxxxxxx/ -b chrome
```

## Handling failures

- **`yt-dlp` missing** — the script prints install instructions; run the
  suggested install command if you have permission to install packages,
  otherwise relay the instructions to the user.
- **Login required / rate limited** — yt-dlp will report this clearly (e.g.
  "Restricted Video" or a 401/429). Ask the user for a `cookies.txt` export
  or which browser they're logged into Instagram with, then retry with
  `-c`/`-b`.
- **Post is private and the user has no access** — stop; don't try to work
  around it.
- **URL isn't a reel/post link** (e.g. a profile URL or a Story link that has
  since expired) — tell the user what's needed instead of guessing.
