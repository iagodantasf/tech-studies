---
title: Index lifecycle management (ILM)
track: elasticsearch
group: Cluster Architecture & Operations
tags: [elasticsearch, ilm]
prerequisites: [indices, shard-allocation-routing]
see-also: [data-streams, hot-warm-cold-architecture, index-templates, snapshots-restore]
---

# Index lifecycle management (ILM)

ILM is a policy engine that automatically moves an index through *phases* — hot, warm, cold, frozen, delete — based on its age or size, so time-series data ages out without a cron job.

## Why it matters

Logs and metrics grow without bound; manually rolling over and deleting indices is error-prone. ILM ties index size/age to actions (rollover, shrink, force-merge, migrate to cheaper [[hot-warm-cold-architecture|tiers]], snapshot, delete), giving predictable storage cost and performance for [[data-streams|data streams]].

## How it works

A policy has up to five phases; each runs actions when its `min_age` (measured from rollover) elapses:

| Phase | Typical actions | Goal |
|---|---|---|
| hot | `rollover`, `set_priority` | Active writes + recent reads |
| warm | `shrink`, `forcemerge`, `allocate` | Read-only, fewer segments |
| cold | `allocate`, `searchable_snapshot` | Rare reads, cheap nodes |
| frozen | `searchable_snapshot` | Search snapshots on object store |
| delete | `delete` | Reclaim space |

- **Rollover** — in hot, `rollover` starts a fresh write index when any threshold trips (e.g. `max_primary_shard_size: 50gb`, `max_age: 1d`, `max_docs`). The alias/data-stream write target advances automatically.
- **Bound via templates** — a policy attaches through an [[index-templates|index template]]'s `index.lifecycle.name`, so every new backing index inherits it.
- **Polling** — ILM checks progress every `indices.lifecycle.poll_interval` (default 10m), so transitions are *near* their `min_age`, not exact.
- **`min_age` is from rollover**, not index creation — a backing index that rolled over at day 1 enters warm at `rollover + warm.min_age`.

## Example

```
PUT _ilm/policy/logs
{ "policy": { "phases": {
  "hot":   { "actions": { "rollover": { "max_primary_shard_size": "50gb", "max_age": "1d" } } },
  "warm":  { "min_age": "7d",  "actions": { "shrink": { "number_of_shards": 1 }, "forcemerge": { "max_num_segments": 1 } } },
  "delete":{ "min_age": "30d", "actions": { "delete": {} } } } } }
```

A `logs` data stream on this policy rolls a new index daily (or at 50 GB), shrinks+merges it after 7 days, and deletes it after 30 — fully unattended.

## Pitfalls

- **Force-merge on the hot phase** — `forcemerge` is expensive and rewrites segments; do it in warm on read-only indices, never while still indexing.
- **`min_age` confusion** — it counts from rollover; setting `hot` rollover *and* a short `warm.min_age` can migrate barely-cooled data prematurely.
- **Rollover needs a write alias / data stream** — pointing a policy at a plain static index means `rollover` never fires and the index never ages.
- **Poll interval lag** — a "delete at 30d" can run minutes-to-poll-interval late; do not rely on ILM for hard compliance deadlines.

## See also

- [[hot-warm-cold-architecture]]
- [[data-streams]]
