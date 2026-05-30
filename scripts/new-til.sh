#!/usr/bin/env bash
# Create a dated TIL note: til/<date>-<slug>.md from templates/til.md
# Usage: ./scripts/new-til.sh "How TLS handshake works"
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TITLE="${*:-}"

if [ -z "$TITLE" ]; then
  echo 'usage: '"$0"' "<title>"' >&2
  exit 1
fi

DATE="$(date +%F)"
SLUG="$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
FILE="$ROOT/til/$DATE-$SLUG.md"

if [ -e "$FILE" ]; then
  echo "error: $FILE already exists" >&2
  exit 1
fi

sed -e "s|{{TITLE}}|$TITLE|g" -e "s|{{DATE}}|$DATE|g" \
    "$ROOT/templates/til.md" > "$FILE"

echo "✓ $FILE"
