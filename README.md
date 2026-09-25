# instagram-reel-downloader

A Claude Code skill that downloads Instagram Reels (and other Instagram video
posts) to a local file, given their URL. It works by shelling out to
[`yt-dlp`](https://github.com/yt-dlp/yt-dlp), since Instagram's page
structure and API change frequently and yt-dlp is actively maintained
against those changes.

Only download content you have the right to save — your own posts, content
someone gave you permission to keep, or content under a license that allows
reuse. This is meant for personal archiving, not for redistributing or
republishing someone else's copyrighted content.

## Requirements

- [`yt-dlp`](https://github.com/yt-dlp/yt-dlp) installed and on your `PATH`:
  ```bash
  pip install -U yt-dlp
  # or
  pipx install yt-dlp
  # or, on macOS
  brew install yt-dlp
  ```

## Usage

### As a Claude Code skill

The skill lives at `.claude/skills/instagram-reel-downloader/`. In a Claude
Code session on this repo, just share an Instagram reel/post URL and ask to
download, save, or grab it — Claude will pick up the skill automatically.

### Running the script directly

You can also invoke the bundled script yourself:

```bash
.claude/skills/instagram-reel-downloader/scripts/download_reel.sh <instagram_url> [options]
```

**Options:**

| Flag | Description |
| --- | --- |
| `-o, --output DIR` | Directory to save the download into (default: current directory) |
| `-c, --cookies FILE` | Path to a `cookies.txt` file (Netscape format), for content that requires being logged in |
| `-b, --cookies-from-browser BROWSER` | Read cookies straight from a local browser profile (`chrome`, `firefox`, `edge`, `brave`, `safari`, ...) instead of a file |
| `-h, --help` | Show usage |

**Examples:**

Download a public reel into the current directory:
```bash
.claude/skills/instagram-reel-downloader/scripts/download_reel.sh https://www.instagram.com/reel/Cxxxxxxxxxx/
```

Save into a specific folder:
```bash
.claude/skills/instagram-reel-downloader/scripts/download_reel.sh https://www.instagram.com/reel/Cxxxxxxxxxx/ -o ~/Downloads/reels
```

Content that requires being logged in (your own private account, an
age-gated post, or when Instagram is rate-limiting anonymous requests) —
export your own Instagram cookies (e.g. with a browser extension like "Get
cookies.txt"; never share your password) and pass the file:
```bash
.claude/skills/instagram-reel-downloader/scripts/download_reel.sh https://www.instagram.com/reel/Cxxxxxxxxxx/ -c cookies.txt
```

Or pull cookies straight from a browser you're already logged into:
```bash
.claude/skills/instagram-reel-downloader/scripts/download_reel.sh https://www.instagram.com/reel/Cxxxxxxxxxx/ -b chrome
```

Downloaded files are named `Uploader - Title [id].ext`.

## Troubleshooting

- **`yt-dlp is not installed`** — install it with one of the commands under
  [Requirements](#requirements).
- **Login required / rate limited** — pass `-c`/`-b` with cookies from an
  account that can view the content (see examples above).
- **Post is private and you don't have access** — the download isn't
  possible (and isn't something this tool is meant to work around).
- **`does not look like an instagram.com URL`** — double check you're
  passing a direct post/reel link (e.g. `https://www.instagram.com/reel/...`),
  not a profile URL or an expired Story link.
