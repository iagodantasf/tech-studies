# Conventions

The durable rules that keep this repo usable as it grows to dozens of topics.

## 1. The learning loop

1. **WIP limit: ≤3 active roadmaps.** More than that and nothing finishes. Active = `status: learning` in its track README.
2. For each node in a roadmap:
   - Skim the node on roadmap.sh.
   - Write `roadmaps/<slug>/notes/<node>.md` from [`templates/topic-note.md`](./templates/topic-note.md).
   - Build a small thing in `playgrounds/<lang>/` and link it from the note.
   - Tick the node's checkbox in `roadmaps/<slug>/README.md` and set your `confidence`.
3. Notable one-off insight → `./scripts/new-til.sh "..."`.
4. **Weekly:** run `node scripts/build-dashboard.mjs`, review the dashboard, pick what's next.

## 2. Note frontmatter

Every topic note starts with YAML frontmatter (Obsidian + tooling read it):

```yaml
---
title: Hash Tables
roadmap: computer-science      # slug — must match a roadmaps/<slug> folder
node: "Data Structures"        # the roadmap.sh node this note covers
status: todo | learning | done
confidence: 0                  # 0–5, your honest self-rating
tags: [cs, data-structures]
created: 2026-05-30
updated: 2026-05-30
sources: []                    # URLs / book refs
---
```

- `status` and `confidence` drive review priority.
- `roadmap` ties the note back to its track (and the dashboard).

## 3. Naming & structure

- **Slugs** = roadmap.sh slugs (e.g. `datastructures-and-algorithms`, `golang`). See `scripts/catalog.json` for the canonical list.
- **Note filenames**: kebab-case, descriptive — `hash-tables.md`, not `note1.md`.
- One concept per note. Split when a note gets long.
- A roadmap track folder:
  ```
  roadmaps/<slug>/
  ├── README.md      # checklist of roadmap.sh nodes + progress + resources
  ├── notes/         # one .md per concept
  └── resources.md   # links, books, courses for this roadmap
  ```

## 4. Linking & tags

- Link between notes with `[[wikilinks]]` — e.g. `see [[big-o-notation]]`.
- Link a note to code: `[[playgrounds/rust/binary-search]]`.
- Tags are topical, lowercase, kebab: `#data-structures`, `#distributed-systems`.
- Prefer a few meaningful tags over many.

## 5. Playgrounds

Organized by **language/tool**, not by roadmap, so each toolchain has one clean root:

| Lang | Convention |
|---|---|
| Rust | one Cargo workspace under `playgrounds/rust/`, one crate per experiment |
| Go | `playgrounds/go/` module, one package per experiment |
| Python | one `uv`/venv env, scripts + notebooks |
| TS/JS | one pnpm workspace |

See [`playgrounds/README.md`](./playgrounds/README.md). Cross-link experiments from the notes that motivated them.

## 6. Dashboard

`DASHBOARD.md` is **generated** — don't hand-edit it. It reads `scripts/catalog.json` (every roadmap) and counts ticked checkboxes in each `roadmaps/<slug>/README.md`. Roadmaps without a folder show `not-started`.
