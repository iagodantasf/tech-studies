#!/usr/bin/env bash
# Scaffold a learning track: roadmaps/<slug>/ from templates/roadmap.md
# Usage: ./scripts/new-roadmap.sh <slug>
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SLUG="${1:-}"

if [ -z "$SLUG" ]; then
  echo "usage: $0 <slug>   (see scripts/catalog.json for slugs)" >&2
  exit 1
fi

# Validate slug + fetch title from catalog (node is required by build-dashboard anyway).
TITLE="$(node -e '
  const fs=require("fs");
  const c=JSON.parse(fs.readFileSync(process.argv[1],"utf8"));
  const r=c.roadmaps.find(x=>x.slug===process.argv[2]);
  if(!r){process.exit(2)} process.stdout.write(r.title);
' "$ROOT/scripts/catalog.json" "$SLUG" 2>/dev/null)" || {
  echo "error: unknown slug '$SLUG' — not in scripts/catalog.json" >&2
  exit 1
}

DIR="$ROOT/roadmaps/$SLUG"
if [ -e "$DIR" ]; then
  echo "error: $DIR already exists" >&2
  exit 1
fi

URL="https://roadmap.sh/$SLUG"
DATE="$(date +%F)"

mkdir -p "$DIR/notes"
sed -e "s|{{TITLE}}|$TITLE|g" \
    -e "s|{{SLUG}}|$SLUG|g" \
    -e "s|{{URL}}|$URL|g" \
    -e "s|{{DATE}}|$DATE|g" \
    "$ROOT/templates/roadmap.md" > "$DIR/README.md"

printf '# %s — resources\n\n- \n' "$TITLE" > "$DIR/resources.md"

node "$ROOT/scripts/build-dashboard.mjs"
echo "✓ created roadmaps/$SLUG/  → now fill in the nodes from $URL"
