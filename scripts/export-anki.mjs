#!/usr/bin/env node
// Export low-confidence notes to an Anki-importable TSV (spaced repetition).
//
// Scans roadmaps/<slug>/notes/*.md, keeps notes whose frontmatter `confidence`
// is <= THRESHOLD (default 2), and writes anki-export.tsv at the repo root:
//   Front = note title   Back = its TL;DR   Tags = frontmatter tags + roadmap
//
// In Anki: File → Import → pick anki-export.tsv (the header lines below tell
// Anki it's tab-separated, HTML-enabled, with tags in column 3).
//
// Usage:  node scripts/export-anki.mjs [maxConfidence]
import { readFileSync, writeFileSync, existsSync, readdirSync, statSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const ROOT = dirname(dirname(fileURLToPath(import.meta.url)));
const THRESHOLD = Number.parseInt(process.argv[2] ?? "2", 10);

function frontmatter(md) {
  const m = md.match(/^---\n([\s\S]*?)\n---/);
  return m ? m[1] : "";
}
function field(fm, key) {
  const m = fm.match(new RegExp(`^${key}:\\s*(.+)$`, "m"));
  return m ? m[1].trim().replace(/^["']|["']$/g, "") : "";
}
function tags(fm) {
  const m = fm.match(/^tags:\s*\[(.*?)\]/m);
  return m ? m[1].split(",").map((t) => t.trim().replace(/\s+/g, "-")).filter(Boolean) : [];
}
function tldr(md) {
  const m = md.match(/##\s*TL;DR\s*\n([\s\S]*?)(?=\n##\s|$)/i);
  return m ? m[1].trim() : "";
}
// Minimal markdown → HTML so cards render with html:true.
function toHtml(s) {
  return s
    .replace(/\t/g, " ")
    .replace(/\*\*(.+?)\*\*/g, "<b>$1</b>")
    .replace(/(^|[^*])\*([^*]+?)\*/g, "$1<i>$2</i>")
    .replace(/`([^`]+?)`/g, "<code>$1</code>")
    .replace(/\r?\n/g, "<br>")
    .trim();
}

// Collect note files: roadmaps/*/notes/*.md
const roadmapsDir = join(ROOT, "roadmaps");
const notes = [];
if (existsSync(roadmapsDir)) {
  for (const slug of readdirSync(roadmapsDir)) {
    const notesDir = join(roadmapsDir, slug, "notes");
    if (!existsSync(notesDir) || !statSync(notesDir).isDirectory()) continue;
    for (const file of readdirSync(notesDir)) {
      if (file.endsWith(".md")) notes.push(join(notesDir, file));
    }
  }
}

const rows = [];
let skipped = 0;
for (const path of notes) {
  const md = readFileSync(path, "utf8");
  const fm = frontmatter(md);
  const confidence = Number.parseInt(field(fm, "confidence") || "0", 10);
  if (Number.isNaN(confidence) || confidence > THRESHOLD) {
    skipped++;
    continue;
  }
  const title = field(fm, "title") || path;
  const back = tldr(md);
  if (!back) {
    skipped++;
    continue;
  }
  const cardTags = [...tags(fm)];
  const roadmap = field(fm, "roadmap");
  if (roadmap) cardTags.push(roadmap);
  cardTags.push(`confidence-${confidence}`);
  rows.push([toHtml(title), toHtml(back), cardTags.join(" ")].join("\t"));
}

const out = ["#separator:tab", "#html:true", "#tags column:3", ...rows].join("\n") + "\n";
const outPath = join(ROOT, "anki-export.tsv");
writeFileSync(outPath, out);
console.log(
  `anki-export.tsv written — ${rows.length} card(s) at confidence <= ${THRESHOLD} ` +
    `(${skipped} note(s) skipped) from ${notes.length} note(s).`
);
