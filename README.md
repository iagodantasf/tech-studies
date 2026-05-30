# tech-studies

A structured **wiki** for studying tech, organized around every [roadmap.sh](https://roadmap.sh/roadmaps)
roadmap. Each roadmap is a *suggested path* of nodes; each node can have a **lesson** that teaches it.

> **This is an [Obsidian](https://obsidian.md)-compatible vault.** Pages are plain markdown with
> frontmatter, `[[wikilinks]]`, and `#tags`. Open the folder as a vault for backlinks + graph, or
> browse the published site / GitHub.

## Quickstart

```bash
# scaffold a new roadmap (creates roadmaps/<catDir>/<slug>/ from the template)
./scripts/new-roadmap.sh computer-science

# write a lesson for one of its nodes
./scripts/new-lesson.sh computer-science "Data structures" "Hash tables"

# regenerate the catalog (coverage per roadmap)
node scripts/build-dashboard.mjs
```

Then open **[CATALOG.md](./CATALOG.md)** for coverage across all roadmaps.

## Layout

| Path | What |
|---|---|
| [`CATALOG.md`](./CATALOG.md) | Coverage (lessons written / nodes) across every roadmap (generated) |
| [`CONVENTIONS.md`](./CONVENTIONS.md) | The wiki model + how lessons are structured |
| `roadmaps/<catDir>/<slug>/` | One roadmap per topic: a grouped node path + `lessons/` + resources |
| `playgrounds/<lang>/` | Runnable code experiments, organized by language/tool |
| `projects/` | Larger practice builds |
| `library/` | Notes on books, courses, papers |
| `templates/` | Lesson + roadmap scaffolds |
| `scripts/` | Automation (scaffold roadmaps/lessons, build the catalog) |

Roadmaps are filed by type — `role-based`, `skill-based`, `best-practices`, `beginner` — so the
explorer groups them.

## How it's structured

Read **[CONVENTIONS.md](./CONVENTIONS.md)** — it defines the roadmap → node → lesson model, the
frontmatter, tags, and the `lessons/<group>/index.md` maps of content.
