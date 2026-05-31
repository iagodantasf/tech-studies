---
title: Kibana
track: elasticsearch
group: The Elastic Stack
tags: [elasticsearch, kibana]
prerequisites: [the-elastic-stack-elk-elastic]
see-also: [logstash, elastic-agent-fleet, apm-observability]
---

# Kibana

Kibana is the browser-based UI and management plane for the Elastic Stack — it queries Elasticsearch over REST and renders dashboards, runs Dev Tools, and drives stack administration.

## Why it matters

Elasticsearch ships no GUI; Kibana *is* how humans see the data and operate the cluster. It is also a stateful service — it stores dashboards, index patterns, alert rules, and ILM/Fleet config inside the cluster in a `.kibana` [[indices|index]], so it is not a throwaway client. Most teams reach for it first for ad-hoc [[query-dsl-overview|queries]], [[bucket-aggregations|aggregation]] dashboards, and observability.

## How it works

Kibana is a Node.js server that the browser talks to; it never queries Elasticsearch directly from the browser.

```
browser ──▶ Kibana (Node, :5601) ──REST──▶ Elasticsearch (:9200)
```

- **Data views** (formerly index patterns) — a named pattern like `logs-*` plus a default time field; nearly every visualization needs one.
- **Dev Tools Console** — autocompleting editor for raw [[rest-api|REST]] calls; the fastest way to test [[query-dsl-overview|Query DSL]] without curl.
- **Saved objects** — dashboards, visualizations, data views, alert rules; live in the `.kibana` index and are exported/imported as NDJSON for promotion across environments.
- **Spaces** — logical partitions of saved objects, tied to [[role-based-access-control-rbac|RBAC]] so a team sees only its own dashboards.

| Surface | Use |
|---|---|
| Discover | Raw doc search + field filtering |
| Lens / Dashboard | Drag-and-drop aggregation charts |
| Dev Tools | Hand-written REST / DSL |
| Stack Management | ILM, index templates, users/roles |

## Example

Promote a dashboard from staging to prod without rebuilding it:

```
POST /api/saved_objects/_export   { "objects": [ { "type": "dashboard", "id": "sales-overview" } ] }
# yields NDJSON including the dashboard AND its referenced data views + visualizations
POST /api/saved_objects/_import?overwrite=true   (multipart NDJSON body)
```

## Pitfalls

- **Version lockstep** — Kibana must match the Elasticsearch minor version exactly; a mismatch refuses to start or breaks features. Upgrade them together during [[rolling-upgrades]].
- **`.kibana` is precious** — losing it loses every dashboard, rule, and data view; include it in [[snapshots-restore|snapshots]].
- **Dashboards over wide time ranges** — a "last 90 days" dashboard with many panels fans out heavy aggregations and can hammer the cluster; cache via the [[caching-query-request-cache|request cache]] and bound the range.
- **Default `elastic` superuser in the UI** — convenient but logs no per-user audit trail; give people scoped roles instead.

## See also

- [[logstash]]
- [[elastic-agent-fleet]]
