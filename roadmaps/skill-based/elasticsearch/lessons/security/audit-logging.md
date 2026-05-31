---
title: Audit logging
track: elasticsearch
group: Security
tags: [elasticsearch, audit-logging]
prerequisites: [authentication-users, role-based-access-control-rbac]
see-also: [api-keys, field-document-level-security, tls-encryption]
---

# Audit logging

Audit logging records who did what to the cluster — authentication outcomes, access grants/denials, and connection events — as a structured JSON trail for security forensics and compliance.

## Why it matters

When a key leaks or a `403` storm appears, you need to know *which principal*, *from which IP*, *hit which index*, and *was it allowed*. RBAC and [[api-keys|API keys]] control access in the moment; audit logging is the after-the-fact record that satisfies SOC 2 / PCI requirements and powers "who deleted the orders index?" investigations. It is **off by default** because it is verbose and adds I/O.

## How it works

Enabled with `xpack.security.audit.enabled: true`; each node writes a `<cluster>_audit.json` file, one JSON object per event.

| Event type | Fires when | Key fields |
|---|---|---|
| `authentication_success` | Credential verified | `user.name`, `realm` |
| `authentication_failed` | Bad credential | `origin.address` |
| `access_denied` | RBAC blocks a request | `privileges`, `indices` |
| `access_granted` | Action allowed | `request.name`, `indices` |
| `connection_denied` | IP filter rejects | `origin.address` |

- **Filtering is essential** — `include`/`exclude` event lists and `ignore_filters` (by user, index pattern, action) cut noise; logging `access_granted` for every search can dwarf your real data volume.
- **Per-node, local files** — events are not centralized automatically; ship `*_audit.json` with [[beats-filebeat-metricbeat|Filebeat]] into a separate, locked-down monitoring cluster.
- **Structured fields** — `request.id` correlates the grant/denied pair for one request; `user.run_as` captures impersonation.
- Some settings (the audited event types) are **static** — set in `elasticsearch.yml` and restart; only filter policies are dynamic.

## Example

Audit only security-relevant events, ignoring noisy reads:

```
xpack.security.audit.enabled: true
xpack.security.audit.logfile.events.exclude: [ access_granted ]
xpack.security.audit.logfile.events.emit_request_body: false
```

A denied delete then appears as:

```
{ "event.action":"access_denied", "user.name":"jdoe",
  "privileges":["indices:admin/delete"], "indices":["orders"],
  "origin.address":"10.2.0.7" }
```

## Pitfalls

- **`emit_request_body: true` in production** — logs full query/doc bodies, leaking the PII that [[field-document-level-security|document security]] was protecting; enable only for targeted debugging.
- **Auditing everything** — `access_granted` on a busy cluster can multiply log volume 10x and fill disks, taking nodes down.
- **Leaving audit files on the data nodes** — an attacker with node access can edit them; forward to an append-only store immediately.
- **Assuming it's on** — security being enabled does *not* enable auditing; it is a separate flag, often discovered missing during an incident.

## See also

- [[role-based-access-control-rbac]]
- [[api-keys]]
