---
title: Snapshots & restore
track: elasticsearch
group: Cluster Architecture & Operations
tags: [elasticsearch, snapshots]
prerequisites: [indices, shards-replicas]
see-also: [index-lifecycle-management-ilm, cluster-health-green-yellow-red, rolling-upgrades]
---

# Snapshots & restore

A snapshot is an incremental backup of indices (and optionally cluster state) written to a *repository* on shared storage; restore copies those shards back into a running cluster.

## Why it matters

Replicas protect against node loss, not against a bad delete, a corrupt mapping, or a region failure — snapshots are the actual backup. They also enable cross-cluster data movement, [[index-lifecycle-management-ilm|ILM]] searchable-snapshot tiers, and disaster recovery to a fresh cluster.

## How it works

Snapshots register against a repository (S3, GCS, Azure, shared FS) and are **incremental at the [[segments|segment]] level** — each snapshot stores only segments not already in the repo.

| Property | Detail |
|---|---|
| Granularity | Per index (or [[data-streams]]); pick a subset |
| Incremental unit | Lucene segments, deduped across snapshots |
| Consistency | Point-in-time per shard at snapshot start |
| Restore target | Must be same or one major version back |

- **Repository first** — `PUT _snapshot/<repo>` once; all snapshots live under it and share deduped segment files.
- **Restore is selective** — choose indices, rename via `rename_pattern`/`rename_replacement`, and override settings (e.g. drop `number_of_replicas` to 0 to restore faster).
- **Can't restore an open index** — the target index must be closed or not exist; restore won't overwrite a live one.
- **SLM** — Snapshot Lifecycle Management schedules snapshots + retention (`PUT _slm/policy/...`) so backups run on cron with automatic pruning.
- **Deleting a snapshot** only removes segments no *other* snapshot references — safe and cheap.

## Example

```
PUT _snapshot/s3_repo { "type":"s3", "settings":{ "bucket":"es-backups" } }

PUT _snapshot/s3_repo/snap-2026-05-30
{ "indices":"logs-*", "include_global_state": false }

POST _snapshot/s3_repo/snap-2026-05-30/_restore
{ "indices":"logs-2026.05.29",
  "rename_pattern":"(.+)", "rename_replacement":"restored-$1",
  "index_settings": { "index.number_of_replicas": 0 } }
```

First snapshot copies everything; the next day's snapshot of `logs-*` uploads only new segments — often a fraction of total size.

## Pitfalls

- **No repo redundancy** — a single-region S3 bucket is a single point of failure; replicate the bucket or keep a second repo for true DR.
- **Restoring onto an existing index** — fails unless closed/renamed; teams often forget and the restore errors mid-run.
- **`include_global_state: true` on partial restore** — can clobber cluster-wide templates/settings on the target; usually keep it `false`.
- **Version skew** — you cannot restore a snapshot taken on a *newer* major version into an older cluster; plan DR clusters at ≥ source version.

## See also

- [[index-lifecycle-management-ilm]]
- [[rolling-upgrades]]
