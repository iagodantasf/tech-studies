# Conventions

The durable rules that keep this repo usable as a structured wiki across dozens of topics.

## 1. The model

- A **roadmap** is a *suggested path* — an ordered, grouped list of nodes for a topic, mirrored
  from [roadmap.sh](https://roadmap.sh). It points the way; it is not a personal progress tracker.
- A **node** is one concept on that path (e.g. *Hash tables*).
- A **lesson** is the wiki page that teaches a node. Lessons are the real content.
- Roadmaps are filed by **type** so the explorer groups them:
  `Role-based`, `Skill-based`, `Best Practices`, `Beginner`.

```
roadmaps/<catDir>/<slug>/
├── README.md      # the roadmap: grouped nodes, each a [[link]] to its lesson (or plain text)
├── resources.md   # books, docs, courses for this topic
└── lessons/
    └── <group>/
        ├── index.md          # MOC: lists this group's lessons in order
        └── <node>.md         # one lesson per node
```

`<catDir>` is `role-based` · `skill-based` · `best-practices` · `beginner`.

## 2. Writing a lesson

1. Pick a node from a roadmap README.
2. `./scripts/new-lesson.sh <track-slug> "<Group>" "<Node title>"` — scaffolds
   `lessons/<group>/<node>.md` from [`templates/lesson.md`](./templates/lesson.md) and refreshes the
   group's `index.md` MOC.
3. Write it as teaching content: summary → why it matters → how it works → example → pitfalls →
   see also. Link a `playgrounds/<lang>/` experiment when one exists.
4. In the track README, turn that node from plain text into `- [[<node>]]`.

## 3. Lesson frontmatter

```yaml
---
title: Hash Tables
track: computer-science        # slug — must match a roadmaps/<catDir>/<slug> folder
group: Data structures         # the node group it belongs to
tags: [cs, data-structures]
prerequisites: [[arrays-and-dynamic-arrays]]   # graph edges
see-also: [[linked-lists]]
---
```

No `status`, `confidence`, or dates — this is a wiki, not a tracker. `prerequisites` and `see-also`
feed the Obsidian/Quartz graph.

## 4. Naming & linking

- **Slugs** = roadmap.sh slugs (e.g. `datastructures-and-algorithms`, `golang`). See
  `scripts/catalog.json` for the canonical list.
- **Lesson filenames**: kebab-case of the node title — `hash-tables.md`, not `note1.md`.
- One node per lesson. Split when a lesson gets long.
- Link between lessons with `[[wikilinks]]`; link to code as `playgrounds/rust/binary-search`.
- Tags are topical, lowercase, kebab: `#data-structures`, `#distributed-systems`. A few meaningful
  tags beat many.

## 5. Playgrounds

Organized by **language/tool**, not by roadmap, so each toolchain has one clean root:

| Lang | Convention |
|---|---|
| Rust | one Cargo workspace under `playgrounds/rust/`, one crate per experiment |
| Go | `playgrounds/go/` module, one package per experiment |
| Python | one `uv`/venv env, scripts + notebooks |
| TS/JS | one pnpm workspace |

See [`playgrounds/README.md`](./playgrounds/README.md). Cross-link experiments from the lessons that
motivate them.

## 6. Catalog

`CATALOG.md` (and the site home `index.md`) are **generated** — don't hand-edit them. Run
`node scripts/build-dashboard.mjs`. It reads `scripts/catalog.json` and, per roadmap, reports
**coverage** = lessons written / nodes in the path. New roadmaps are scaffolded with
`./scripts/new-roadmap.sh <slug>`.
