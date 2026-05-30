# tech-studies

My long-lived workspace for studying tech — notes, playgrounds, and tracked progress against every [roadmap.sh](https://roadmap.sh/roadmaps) roadmap.

> **This is an [Obsidian](https://obsidian.md)-compatible vault.** Notes are plain markdown with frontmatter, `[[wikilinks]]`, and `#tags`. Open the folder as a vault for backlinks + graph, or just read it on GitHub.

## Quickstart

```bash
# start tracking a new roadmap (creates roadmaps/<slug>/ from template)
./scripts/new-roadmap.sh computer-science

# jot a quick "today I learned"
./scripts/new-til.sh "How TLS handshake works"

# regenerate the progress dashboard
node scripts/build-dashboard.mjs
```

Then open **[DASHBOARD.md](./DASHBOARD.md)** to see status across all roadmaps.

## Layout

| Path | What |
|---|---|
| [`DASHBOARD.md`](./DASHBOARD.md) | Progress across every roadmap (generated) |
| [`CONVENTIONS.md`](./CONVENTIONS.md) | How notes are structured + the learning loop |
| `roadmaps/<slug>/` | One learning track per roadmap.sh roadmap: checklist + notes |
| `playgrounds/<lang>/` | Runnable code experiments, organized by language/tool |
| `projects/` | Larger practice builds |
| `library/` | Notes on books, courses, papers |
| `til/` | Today-I-Learned micro-notes (dated) |
| `templates/` | Note + scaffold templates |
| `scripts/` | Automation (scaffold tracks, build dashboard) |

## How I use it

Read **[CONVENTIONS.md](./CONVENTIONS.md)** — it defines the frontmatter, tags, and the per-topic learning loop. Rule of thumb: **≤3 active roadmaps at a time.**
