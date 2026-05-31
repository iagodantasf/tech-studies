---
title: Index templates
track: elasticsearch
group: Performance & Scaling
tags: [elasticsearch, index-templates]
prerequisites: [mappings, indices]
see-also: [data-streams, index-lifecycle-management-ilm, sharding-strategy]
---

# Index templates

An index template applies predefined [[mappings|mappings]], settings, and aliases to any new index whose name matches a glob pattern — so auto-created time-series indices are born correctly configured.

## Why it matters

In logging and metrics, indices are created on the fly (by [[data-streams|data streams]], rollover, or first write). Without a template, each gets default settings and [[dynamic-vs-explicit-mapping|dynamic mapping]] — wrong shard counts, fields typed as `text` that should be `keyword`, no [[index-lifecycle-management-ilm|ILM]] policy. Templates make "every `logs-*` index" provably consistent.

## How it works

Modern Elasticsearch (7.8+) uses **composable** index templates plus reusable **component templates**:

```
PUT _component_template/logs-settings
{ "template": { "settings": { "number_of_shards": 3, "index.lifecycle.name": "logs-ilm" } } }

PUT _index_template/logs
{ "index_patterns": ["logs-*"], "composed_of": ["logs-settings", "logs-mappings"],
  "priority": 200, "data_stream": {} }
```

- **Composable, not concatenated** — exactly **one** index template wins per new index (highest `priority`); it isn't merged with other index templates. Only its listed `composed_of` component templates are layered in.
- **Layering order** — component templates merge in array order, then the inline `template` block overrides, then explicit settings in the create request win last.
- **`priority`** breaks ties between overlapping patterns; reserve high numbers and avoid a catch-all `*` template that shadows everything.
- **Applied at creation only** — editing a template never touches existing indices; the next new (or rolled-over) index picks it up.

## Example

Two log streams share infra but differ in retention. One `logs-settings` component (shards + refresh) is reused by both `logs-app-*` (priority 200, 30-day ILM) and `logs-audit-*` (priority 200, 365-day ILM) index templates. Changing shard count means editing one component template; it takes effect on the next rollover, leaving today's hot index untouched.

## Pitfalls

- **Legacy `_template` vs `_index_template`** — the old `PUT _template` API still exists and *merges*, but mixing the two causes confusing precedence; prefer composable templates.
- **Expecting retroactive changes** — a fixed mapping bug needs a [[reindex-api|reindex]]; the template alone won't repair live indices.
- **Overlapping patterns at equal priority** — ambiguous matches are rejected at create time; keep priorities distinct.
- **`number_of_replicas` baked too high** for a single-node dev cluster leaves every index stuck yellow.

## See also

- [[data-streams]]
- [[index-lifecycle-management-ilm]]
