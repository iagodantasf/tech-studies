---
title: Field & document level security
track: elasticsearch
group: Security
tags: [elasticsearch, document-security]
prerequisites: [role-based-access-control-rbac, query-dsl-overview]
see-also: [api-keys, audit-logging, term-level-queries]
---

# Field & document level security

Field-level security (FLS) and document-level security (DLS) extend a role beyond *which indices* to *which fields and which rows* a principal may see within one index.

## How it works

Both are configured on an `indices` entry of an [[role-based-access-control-rbac|RBAC]] role, not as separate objects.

- **FLS** — `field_security` lists `grant` (and optionally `except`) field patterns; non-granted fields are stripped from `_source` and become unsearchable for that role.
- **DLS** — a `query` (a [[query-dsl-overview|Query DSL]] filter) is AND-ed onto every search; documents not matching it are invisible, as if they did not exist.
- **Evaluated per role, union-merged** — with multiple roles, FLS grants and DLS queries are combined with OR, so an extra broad role can *widen* visibility unexpectedly.
- **`_id` and metadata** stay visible; you restrict `_source` fields, not the doc's existence under FLS.

## Why it matters

One `events` index often holds rows for many tenants and columns of mixed sensitivity (PII, salary, internal flags). DLS lets a `tenant_a` role see only `tenant == "a"` documents; FLS hides the `ssn` field from analysts while keeping it for fraud. This avoids physically splitting data into per-tenant indices, which would multiply [[shards-replicas|shards]] and complicate aggregations.

## Example

A role limited to one tenant's rows, with PII fields masked:

| Mechanism | Config on the role |
|---|---|
| DLS | `query: { "term": { "tenant": "a" } }` |
| FLS | `field_security: { "grant":["*"], "except":["ssn","dob"] }` |

```
POST /_security/role/tenant_a_analyst
{ "indices":[ { "names":["events-*"], "privileges":["read"],
    "query":"{\"term\":{\"tenant\":\"a\"}}",
    "field_security":{ "grant":["*"], "except":["ssn","dob"] } } ] }
```

A search by this role over 10M docs silently returns only tenant-a rows, never exposing `ssn` in `_source` or `fields`.

## Pitfalls

- **DLS query is a filter, runs every search** — an expensive `query` (scripts, wildcards) taxes *all* of this role's traffic; keep it a cheap [[term-level-queries|term]]/`terms` clause.
- **FLS breaks aggregations on hidden fields** — aggregating a non-granted field returns zero buckets, not an error, which masks bugs.
- **Union widening** — granting a user a second role without DLS removes the row filter entirely (OR of "all" wins); audit combined roles.
- **`copy_to` / `_source` leakage** — a hidden field copied into a visible field, or reconstructable via highlighting, can leak; verify with the affected user.

## See also

- [[role-based-access-control-rbac]]
- [[api-keys]]
