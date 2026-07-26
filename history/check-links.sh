#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

rg --no-filename --only-matching \
  'https://[^)<>`[:space:]]+' \
  --glob '*.md' |
  sort -u |
  xargs -P 8 -n 1 bash -c '
    url="$1"
    status="$(curl --http1.1 --location --silent --show-error \
      --output /dev/null --max-time 25 --retry 1 \
      --write-out "%{http_code}" "$url" || true)"
    case "$status" in
      2*|3*) printf "OK   %s %s\n" "$status" "$url" ;;
      401|403|429) printf "WARN %s %s\n" "$status" "$url" ;;
      *) printf "FAIL %s %s\n" "$status" "$url"; exit 1 ;;
    esac
  ' _
