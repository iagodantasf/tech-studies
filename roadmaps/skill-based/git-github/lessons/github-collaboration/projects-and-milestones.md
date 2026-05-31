---
title: Projects and milestones
track: git-github
group: GitHub collaboration
tags: [git-github, planning]
prerequisites: [github-issues]
see-also: [labels-and-assignees, pull-requests]
---

# Projects and milestones

Two planning layers over [[github-issues|issues]] and [[pull-requests|PRs]]: Projects (flexible boards/tables/roadmaps with custom fields) and milestones (a dated bucket of work tracked to a completion percentage).

## Why it matters

Issues alone are a flat list with no notion of sprint, status column, or target date. Projects turn them into a planning surface — Kanban, spreadsheet, or timeline — and milestones answer "are we on track for the 4.2 release?" with a live progress bar. The current **Projects** (the table/board product, GA 2022) replaced the old per-repo "classic" projects and adds custom fields, saved views, and org-wide scope, which is why it's now the default for cross-repo roadmaps.

## How it works

A **Project** is a database of items (issues, PRs, or draft notes) with custom fields, rendered as multiple **views**. A **milestone** is a named, optionally dated grouping scoped to one repo.

| Concept | Scope | Tracks | Key fields |
|---|---|---|---|
| Project (new) | Org or repo | Issues, PRs, drafts | Status, custom (Iteration, Priority, Number) |
| Milestone | Single repo | Issues, PRs | Due date, % complete |

- Project views share one item set but differ in layout/filter/sort: a **Board** view for Kanban, a **Table** for bulk edits, a **Roadmap** for dates.
- **Iteration** fields model sprints; **automation/workflows** can auto-move an item to "Done" when its issue closes.
- Milestone progress = closed items / total items; it's purely a count, so a 2-line typo fix and a month-long epic each count as one.

## Example

```
Milestone "v4.2" — due 2026-06-15
  ████████░░  8 of 11 closed (73%)

Project "Platform Roadmap" (Board view), grouped by Status:
  Todo        In Progress      Done
  #913 leak   #908 retry       #901 docs
  #915 docs   #912 metrics
```

## Pitfalls

- **Classic vs new confusion** — guides referencing per-repo "Projects (classic)" predate the table-based product; classic is deprecated for new projects.
- **Milestone % is just a count** — weighting matters; track effort with a custom Project field, not the milestone bar.
- **Cross-repo milestones don't exist** — a milestone lives in one repo; coordinate multi-repo releases with a Project, not milestones.
- **Orphaned items** — closing an issue removes it from milestone math but it lingers in a Project unless a workflow archives it.

## See also

- [[github-issues]]
- [[labels-and-assignees]]
