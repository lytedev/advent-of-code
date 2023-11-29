#!/usr/bin/env sh

AOC_YEAR="${AOC_YEAR:-2023}"
if [ "$#" -lt 1 ]; then
  echo "Error: No day provided"
  exit 1
fi
DAY="$1"
f="$HOME/.cache/aoc$AOC_YEAR/$DAY.input"
if [ -f "$f" ]; then
  echo "Skip: File already exists"
  exit 0
fi
url="https://adventofcode.com/$AOC_YEAR/day/$DAY/input"
cookie_file="$HOME/.advent-of-code-session-cookie"
if [[ ! -f "$cookie_file" ]]; then
  echo "Cookie file not found: $cookie_file"
  exit 1
fi
cookie="$(cat "$cookie_file")"
mkdir -p "$(dirname "$f")"
if curl -s --fail-with-body -X GET "$url" -H "Cookie:$cookie" > "$f"; then
  cat "$f"
  echo "Downloaded $url to $f - contents have been output to this terminal as well"
  exit 0
else
  echo "Error: curl failed (are you sure the input is available now?)"
  rm -f "$f"
  exit 1
fi
