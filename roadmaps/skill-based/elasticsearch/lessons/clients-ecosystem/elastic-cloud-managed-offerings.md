---
title: Elastic Cloud / managed offerings
track: elasticsearch
group: Clients & Ecosystem
tags: [elasticsearch, elastic-cloud]
prerequisites: [nodes-cluster, hot-warm-cold-architecture]
see-also: [snapshots-restore, rolling-upgrades, index-lifecycle-management-ilm]
---

# Elastic Cloud / managed offerings

Elastic Cloud is Elastic's hosted, managed Elasticsearch + [[kibana|Kibana]] service that runs deployments on AWS/GCP/Azure and automates provisioning, upgrades, scaling, snapshots, and security so teams skip cluster operations.

## Why it matters

Running Elasticsearch well is real operational work — capacity planning, [[rolling-upgrades|rolling upgrades]], [[snapshots-restore|snapshot]] schedules, TLS, node failure recovery. Managed offerings absorb that toil, which is why most new adopters start there. Knowing the landscape (Elastic Cloud vs AWS's own service vs self-managed) also prevents a costly trap: the AWS "OpenSearch" fork is a *different product* and not API-compatible with current Elasticsearch.

## How it works

You declare a deployment topology by hardware tiers; the platform maps that onto [[node-roles-master-data-ingest-coordinating|node roles]] and an [[hot-warm-cold-architecture|ILM data-tier]] layout and manages the lifecycle.

- **Deployment building blocks** — sized hot/warm/cold/frozen data tiers, dedicated masters, ML and ingest nodes; you pick RAM/zone counts, not individual VMs.
- **Frozen tier + searchable snapshots** — the cold/frozen tiers back data with object storage, so a [[snapshots-restore|snapshot]] *is* the searchable copy; you pay storage, not hot hardware, for old data.
- **Managed upgrades** — version bumps are orchestrated [[rolling-upgrades|rolling restarts]] with one click, with snapshots taken first.
- **Autoscaling** — tiers can grow on capacity/storage triggers tied to [[index-lifecycle-management-ilm|ILM]] policies.

| Offering | Who runs it | Compatibility |
|---|---|---|
| Elastic Cloud (ESS) | Elastic | current Elasticsearch + full X-Pack |
| Elastic Cloud Enterprise / on K8s | you, via Elastic's operator | same product, your infra |
| AWS OpenSearch Service | AWS | forked from 7.10; **not** Elasticsearch |

## Example

A logging deployment spanning tiers under one ILM policy:

```
hot   (NVMe, 64GB RAM x3 zones)  -> active indexing, last 2 days
warm  (HDD,  cheaper x2)         -> 2–14 days, force-merged, read-only
cold  (searchable snapshot)      -> 14–90 days, data in object store
frozen (searchable snapshot)     -> 90d–1y, fetched on demand
```

ILM rolls each [[data-streams|data stream]] index down the tiers automatically; the frozen tier keeps a year queryable at a fraction of hot cost.

## Pitfalls

- **OpenSearch is a hard fork** — code, APIs, and clients diverged after Elasticsearch 7.10's license change; do not assume new ES features, the `_sql`/Painless behavior, or [[official-language-clients|official clients]] work against it.
- **Cross-zone bandwidth and egress** — multi-AZ replication and snapshot egress to other clouds add cost that the sticker price hides; keep workloads and storage in-region.
- **Managed != tuning-free** — the platform won't fix [[sharding-strategy|oversharding]], bad [[mappings]], or runaway aggregations; you still own data modeling and query hygiene.
- **Version cadence is enforced** — managed services drop very old versions on a schedule; plan upgrades rather than pinning indefinitely.

## See also

- [[snapshots-restore]]
- [[hot-warm-cold-architecture]]
