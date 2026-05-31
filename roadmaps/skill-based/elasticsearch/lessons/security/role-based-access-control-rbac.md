---
title: Role-based access control (RBAC)
track: elasticsearch
group: Security
tags: [elasticsearch, rbac]
prerequisites: [authentication-users]
see-also: [field-document-level-security, api-keys, audit-logging]
---

# Role-based access control (RBAC)

RBAC decides *what* an authenticated principal may do; roles bundle cluster privileges, per-index privileges, and application privileges, and users (or [[api-keys|API keys]]) are granted one or more roles.

## Why it matters

After [[authentication-users|authentication]] proves identity, authorization is the gate that stops a `logs_reader` from running `DELETE /orders` or reading the `.security` index. Roles model real teams — ingest pipelines, analysts, Kibana dashboards — with *least privilege*, and combine additively so you compose narrow roles instead of minting one god-role.

## How it works

A role has three privilege scopes:

| Scope | Granularity | Examples |
|---|---|---|
| `cluster` | Whole cluster | `monitor`, `manage_ilm`, `manage_security` |
| `indices` | Per index pattern | `read`, `write`, `create_index`, `view_index_metadata` |
| `applications` | Kibana features/spaces | `feature_dashboard.read` |

- **Index patterns** — privileges bind to name patterns (`logs-*`), so a role auto-covers tomorrow's daily index.
- **Additive only** — there is no explicit *deny*; effective permissions are the union of all assigned roles. To remove access, remove the role, not add a negation.
- **Field/document scoping** — an `indices` entry may also carry `field_security` and a `query`, narrowing *which fields/rows* are visible (see [[field-document-level-security]]).
- **Action names** — privileges expand to internal actions like `indices:data/read/search`; a denied request returns `403` naming the missing privilege.
- Built-in roles (`viewer`, `editor`, `superuser`, `kibana_system`) cover common cases — prefer composing them over `superuser`.

## Example

A read-only logs role, scoped and verified:

```
POST /_security/role/logs_reader
{ "cluster":["monitor"],
  "indices":[ { "names":["logs-*"], "privileges":["read","view_index_metadata"] } ] }

POST /_security/user/jdoe/_has_privileges
{ "index":[{ "names":["logs-2026.05"], "privileges":["read"] }] }
→ { "has_all_requested": true }
```

## Pitfalls

- **Reaching for `all` on `indices`** — `all` includes `delete_index`; most "writers" need only `write`+`create_index`.
- **Forgetting `monitor`/`view_index_metadata`** — Kibana and clients silently fail health/field-caps calls without these cluster/index privileges.
- **Granting `manage_security`** — lets a user mint roles for *themselves*, a privilege-escalation path; reserve it.
- **Expecting deny rules** — you cannot grant `logs-*` then subtract `logs-secret`; instead never include the secret pattern in the role at all.

## See also

- [[field-document-level-security]]
- [[authentication-users]]
