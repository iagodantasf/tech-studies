#!/usr/bin/env bash
# Scaffold a lesson under a track: roadmaps/<catDir>/<slug>/lessons/<group>/<node>.md
# and (re)generate that group's index.md MOC.
# Usage: ./scripts/new-lesson.sh <track-slug> "<Group>" "<Node title>"
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SLUG="${1:-}"
GROUP="${2:-}"
NODE="${3:-}"

if [ -z "$SLUG" ] || [ -z "$GROUP" ] || [ -z "$NODE" ]; then
  echo 'usage: '"$0"' <track-slug> "<Group>" "<Node title>"' >&2
  exit 1
fi

node - "$ROOT" "$SLUG" "$GROUP" "$NODE" <<'NODE_EOF'
const fs = require("fs");
const path = require("path");
const [ROOT, SLUG, GROUP, NODE] = process.argv.slice(2);
const CAT_DIR = {
  "Role-based": "role-based",
  "Skill-based": "skill-based",
  "Best Practices": "best-practices",
  Beginner: "beginner",
};
const kebab = (s) =>
  s.toLowerCase().normalize("NFKD").replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "");

const catalog = JSON.parse(fs.readFileSync(path.join(ROOT, "scripts", "catalog.json"), "utf8"));
const r = catalog.roadmaps.find((x) => x.slug === SLUG);
if (!r) { console.error(`error: unknown track '${SLUG}'`); process.exit(1); }

const trackDir = path.join(ROOT, "roadmaps", CAT_DIR[r.category], SLUG);
if (!fs.existsSync(trackDir)) { console.error(`error: track folder missing: ${trackDir}`); process.exit(1); }

const groupDir = path.join(trackDir, "lessons", kebab(GROUP));
fs.mkdirSync(groupDir, { recursive: true });

const lessonFile = path.join(groupDir, kebab(NODE) + ".md");
if (fs.existsSync(lessonFile)) { console.error(`error: ${lessonFile} already exists`); process.exit(1); }

const tpl = fs.readFileSync(path.join(ROOT, "templates", "lesson.md"), "utf8");
const lesson = tpl
  .replace(/\{\{TITLE\}\}/g, NODE)
  .replace(/\{\{TRACK\}\}/g, SLUG)
  .replace(/\{\{GROUP\}\}/g, GROUP);
fs.writeFileSync(lessonFile, lesson);

// (Re)generate the group's index.md MOC from the lesson files present.
const files = fs
  .readdirSync(groupDir)
  .filter((f) => f.endsWith(".md") && f !== "index.md")
  .sort();
let moc = `---\ntitle: ${GROUP}\n---\n\n# ${GROUP}\n\nLessons in this group:\n\n`;
for (const f of files) moc += `- [[${f.replace(/\.md$/, "")}]]\n`;
fs.writeFileSync(path.join(groupDir, "index.md"), moc);

console.log(`✓ created ${path.relative(ROOT, lessonFile)}`);
console.log(`  → add it to the track index.md node as [[${kebab(NODE)}]]`);
NODE_EOF

node "$ROOT/scripts/build-dashboard.mjs"
