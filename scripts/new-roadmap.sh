#!/usr/bin/env bash
# Scaffold a roadmap (a suggested path): roadmaps/<catDir>/<slug>/ from templates/roadmap.md
# Usage: ./scripts/new-roadmap.sh <slug>
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SLUG="${1:-}"

if [ -z "$SLUG" ]; then
  echo "usage: $0 <slug>   (see scripts/catalog.json for slugs)" >&2
  exit 1
fi

# Validate slug + fetch "title\tcategory" from catalog.
META="$(node -e '
  const fs=require("fs");
  const c=JSON.parse(fs.readFileSync(process.argv[1],"utf8"));
  const r=c.roadmaps.find(x=>x.slug===process.argv[2]);
  if(!r){process.exit(2)} process.stdout.write(r.title+"\t"+r.category);
' "$ROOT/scripts/catalog.json" "$SLUG" 2>/dev/null)" || {
  echo "error: unknown slug '$SLUG' — not in scripts/catalog.json" >&2
  exit 1
}
TITLE="${META%%$'\t'*}"
CATEGORY="${META#*$'\t'}"

case "$CATEGORY" in
  "Role-based")     CATDIR="role-based" ;;
  "Skill-based")    CATDIR="skill-based" ;;
  "Best Practices") CATDIR="best-practices" ;;
  "Beginner")       CATDIR="beginner" ;;
  *) echo "error: unknown category '$CATEGORY'" >&2; exit 1 ;;
esac

DIR="$ROOT/roadmaps/$CATDIR/$SLUG"
if [ -e "$DIR" ]; then
  echo "error: $DIR already exists" >&2
  exit 1
fi

if [ "$CATEGORY" = "Best Practices" ]; then
  URL="https://roadmap.sh/best-practices/$SLUG"
else
  URL="https://roadmap.sh/$SLUG"
fi

# Escape '&' so sed doesn't expand it to the matched text (titles like "Swift & SwiftUI").
TITLE_ESC="${TITLE//&/\\&}"

mkdir -p "$DIR/lessons"
sed -e "s|{{TITLE}}|$TITLE_ESC|g" \
    -e "s|{{SLUG}}|$SLUG|g" \
    -e "s|{{TRACK}}|$SLUG|g" \
    -e "s|{{CATEGORY}}|$CATEGORY|g" \
    -e "s|{{URL}}|$URL|g" \
    "$ROOT/templates/roadmap.md" > "$DIR/README.md"

printf '# %s — resources\n\n> roadmap.sh: %s\n\n## Docs / references\n- \n' "$TITLE" "$URL" > "$DIR/resources.md"

node "$ROOT/scripts/build-dashboard.mjs"
echo "✓ created roadmaps/$CATDIR/$SLUG/  → now fill in the nodes from $URL"
