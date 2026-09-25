#!/usr/bin/env bash
#
# download_reel.sh - Download an Instagram Reel (or other Instagram video post)
# by shelling out to yt-dlp, which handles Instagram's extraction logic and is
# actively maintained against Instagram's frequent page-structure changes.
#
# Usage:
#   download_reel.sh <instagram_url> [options]
#
# Options:
#   -o, --output DIR              Directory to save the download into (default: current directory)
#   -c, --cookies FILE            Path to a cookies.txt file (Netscape format) for content that
#                                  requires being logged in (private accounts, age-gated posts)
#   -b, --cookies-from-browser B  Read cookies directly from a local browser profile instead
#                                  (e.g. chrome, firefox, edge, brave, safari) — see yt-dlp docs
#                                  for the exact syntax if you need a specific profile/keyring
#   -h, --help                    Show this help text
#
# Examples:
#   ./download_reel.sh https://www.instagram.com/reel/Cxxxxxxxxxx/
#   ./download_reel.sh https://www.instagram.com/reel/Cxxxxxxxxxx/ -o ~/Downloads
#   ./download_reel.sh https://www.instagram.com/reel/Cxxxxxxxxxx/ -c cookies.txt
#   ./download_reel.sh https://www.instagram.com/reel/Cxxxxxxxxxx/ -b chrome

set -euo pipefail

output_dir="."
cookies_file=""
cookies_browser=""
url=""

print_usage() {
  sed -n '2,22p' "$0" | sed 's/^# \{0,1\}//'
}

while [ $# -gt 0 ]; do
  case "$1" in
    -o|--output)
      output_dir="${2:-}"
      shift 2
      ;;
    -c|--cookies)
      cookies_file="${2:-}"
      shift 2
      ;;
    -b|--cookies-from-browser)
      cookies_browser="${2:-}"
      shift 2
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    -*)
      echo "Error: unknown option '$1'" >&2
      print_usage
      exit 1
      ;;
    *)
      if [ -n "$url" ]; then
        echo "Error: multiple URLs given ('$url' and '$1'). Pass one URL at a time." >&2
        exit 1
      fi
      url="$1"
      shift
      ;;
  esac
done

if [ -z "$url" ]; then
  echo "Error: no Instagram URL given." >&2
  print_usage
  exit 1
fi

# Validate this actually looks like an Instagram URL before spending any effort on it.
if ! echo "$url" | grep -Eiq '^https?://(www\.)?instagram\.com/'; then
  echo "Error: '$url' does not look like an instagram.com URL." >&2
  echo "Expected something like: https://www.instagram.com/reel/Cxxxxxxxxxx/" >&2
  exit 1
fi

if ! command -v yt-dlp >/dev/null 2>&1; then
  cat >&2 <<'EOF'
Error: yt-dlp is not installed (or not on PATH).

Install it with one of:
  pip install -U yt-dlp
  pipx install yt-dlp
  brew install yt-dlp        # macOS

See https://github.com/yt-dlp/yt-dlp#installation for other options.
EOF
  exit 1
fi

if [ -n "$cookies_file" ] && [ ! -f "$cookies_file" ]; then
  echo "Error: cookies file '$cookies_file' not found." >&2
  exit 1
fi

mkdir -p "$output_dir"

cmd=(yt-dlp
  --no-playlist
  -o "${output_dir}/%(uploader)s - %(title).100s [%(id)s].%(ext)s"
  "$url"
)

if [ -n "$cookies_file" ]; then
  cmd+=(--cookies "$cookies_file")
elif [ -n "$cookies_browser" ]; then
  cmd+=(--cookies-from-browser "$cookies_browser")
fi

echo "Running: ${cmd[*]}"
"${cmd[@]}"
