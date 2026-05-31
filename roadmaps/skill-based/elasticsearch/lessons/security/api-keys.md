---
title: API keys
track: elasticsearch
group: Security
tags: [elasticsearch, api-keys]
prerequisites: [authentication-users, role-based-access-control-rbac]
see-also: [field-document-level-security, audit-logging, tls-encryption]
---

# API keys

An API key is a long-lived, revocable credential issued by the cluster that authenticates a request without replaying a user password, optionally restricted to a subset of the creator's own privileges.

## Why it matters

Applications, [[beats-filebeat-metricbeat|Beats]], and CI jobs need machine credentials that survive password rotation and can be revoked individually when a host is compromised. Unlike the bearer tokens from the [[authentication-users|token service]] (minutes-long TTL), API keys default to *no expiry* and are stored in the `.security` index, so one leaked key is killed with a single `DELETE` instead of rotating the shared `elastic` password. They are the right credential for every non-human caller.

## How it works

A key has an `id` and a one-time `api_key` secret; clients send the base64 of `id:api_key`.

| Property | Behavior |
|---|---|
| Wire format | `Authorization: ApiKey <base64(id:api_key)>` |
| Privileges | Intersection of creator's roles and the key's `role_descriptors` |
| Expiry | Optional `expiration` (e.g. `30d`); default none |
| Owner | Bound to the creating user; invalidated if that user is deleted |

- **Privilege narrowing** — `role_descriptors` cannot *grant* more than the creator has; the effective set is the intersection, so a key from a `logs_reader` can never write.
- **No reveal after creation** — the `api_key` secret is returned once and only its bcrypt hash is stored; lose it and you reissue.
- **Revocation** — `DELETE /_security/api_key` by `id`, `name`, `username`, or `realm_name`; takes effect on the next request, not retroactively.
- **`encoded` field** — the create response includes a ready-to-use base64 string, so clients skip building it themselves.

## Example

Create a scoped, expiring key and use it:

```
POST /_security/api_key
{ "name":"filebeat-host7", "expiration":"30d",
  "role_descriptors":{ "ship":{ "index":[{ "names":["logs-*"],"privileges":["create_doc"] }] } } }
→ { "id":"VuaC...", "api_key":"ui2lp...", "encoded":"VnVhQzo..." }

GET /_security/_authenticate
Authorization: ApiKey VnVhQzo...
→ { "username":"jdoe", "authentication_type":"api_key" }
```

## Pitfalls

- **Omitting `role_descriptors`** — the key then inherits the creator's *full* privileges; always pass a narrowing descriptor for least privilege.
- **No expiry on long-lived keys** — without `expiration` a forgotten key lives forever; set a TTL and rotate, or audit with `GET /_security/api_key`.
- **Creating keys as `elastic`** — the key inherits superuser and bypasses [[role-based-access-control-rbac|RBAC]] and document security entirely.
- **Logging the `Authorization` header** — the base64 is reversible to the raw secret; scrub it from proxy/access logs and ship only over [[tls-encryption|TLS]].

## See also

- [[role-based-access-control-rbac]]
- [[authentication-users]]
