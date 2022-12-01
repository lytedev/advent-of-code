#!/usr/bin/env sh

AOC_YEAR="${AOC_YEAR:-2022}"
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
cookie="$(cat "$HOME/.advent-of-code-session-cookie")"
mkdir -p "$(dirname "$f")"
if curl --fail-with-body -X GET "$url" -H "Cookie:$cookie" > "$f"; then
  echo "Downloaded $url to $f"
  exit 0
else
  echo "Error: curl failed"
  rm -f "$f"
  exit 1
fi