---
title: Authentication & users
track: elasticsearch
group: Security
tags: [elasticsearch, authentication]
prerequisites: [rest-api]
see-also: [role-based-access-control-rbac, api-keys, tls-encryption]
---

# Authentication & users

Authentication is how Elasticsearch proves *who* is making a request; the security feature ships with a built-in user store plus pluggable realms that map credentials to a verified principal before any [[role-based-access-control-rbac|authorization]] runs.

## Why it matters

Without authentication an open cluster lets anyone `DELETE /*` over HTTP — historically the cause of mass data-wipe extortion on exposed ports 9200. Since 8.0 security is **on by default**: TLS plus a password-protected `elastic` superuser are generated at first start. Every request now carries an identity that RBAC and [[audit-logging|audit logs]] can reason about.

## How it works

A request hits an ordered chain of *realms*; the first that authenticates wins.

| Realm type | Source of truth | Typical use |
|---|---|---|
| `native` | Cluster `.security` index | Built-in users via API |
| `file` | `users` / `users_roles` files | Bootstrap / break-glass |
| `ldap` / `active_directory` | Corporate directory | Enterprise SSO |
| `saml` / `oidc` | IdP (Okta, Azure AD) | [[kibana]] browser login |
| `pki` | Client TLS certificate | Service-to-service |

- **Built-in users** — `elastic` (superuser), `kibana_system`, `logstash_system`, `beats_system`; each service account has *least* privilege, not superuser.
- **Realm order** matters: cheap/local realms (`file`, `native`) should precede network realms so a directory outage doesn't lock out break-glass accounts.
- **Token service** — username/password is exchanged once for a bearer token (`POST /_security/oauth2/token`); browsers and clients then send `Authorization: Bearer …` instead of replaying the password.
- Credentials only travel safely over [[tls-encryption|TLS]]; HTTP Basic without TLS leaks the password.

## Example

Create a native user and verify identity:

```
POST /_security/user/jdoe
{ "password":"<redacted>", "roles":["logs_reader"], "full_name":"J Doe" }

GET /_security/_authenticate    # as jdoe
→ { "username":"jdoe", "roles":["logs_reader"], "authentication_realm":{"name":"native1"} }
```

## Pitfalls

- **Leaving the bootstrap `elastic` password in scripts** — rotate via `elasticsearch-reset-password -u elastic`; never bake the first-start password into CI.
- **Using `elastic` for app traffic** — superuser bypasses all RBAC and document security; create scoped users or [[api-keys|API keys]] instead.
- **Wrong realm order** — putting `ldap` before `file` means an LDAP outage blocks your emergency local login.
- **Disabling security "to make it work"** (`xpack.security.enabled:false`) — removes auth *and* TLS cluster-wide; the cluster becomes wide open.

## See also

- [[role-based-access-control-rbac]]
- [[api-keys]]
