---
title: TLS encryption
track: elasticsearch
group: Security
tags: [elasticsearch, tls]
prerequisites: [nodes-cluster]
see-also: [authentication-users, api-keys, cryptography-basics]
---

# TLS encryption

TLS encrypts and authenticates two distinct channels in a cluster — the HTTP/REST layer clients talk to, and the *transport* layer nodes use to gossip and ship shards — preventing eavesdropping and rogue nodes joining.

## Why it matters

Cluster state, query results, and replicated documents all flow over the transport port (9300) in cleartext unless TLS is on; on the HTTP port (9200) a missing TLS exposes [[authentication-users|Basic-auth passwords]]. Since 8.0 transport TLS is **mandatory** when security is enabled — a node refuses to start otherwise — because certificate-based transport auth is what stops an attacker's node from joining and reading every shard. See [[cryptography-basics]] for the handshake fundamentals.

## How it works

Two independent TLS configs, each with its own keystore/truststore:

| Layer | Port | Verification mode | Who connects |
|---|---|---|---|
| `xpack.security.transport.ssl` | 9300 | `full` (mutual) | Node ↔ node |
| `xpack.security.http.ssl` | 9200 | server-auth (optional client) | Clients, Kibana |

- **Transport requires mutual TLS** — every node presents a cert from a shared CA; `verification_mode: full` checks both the CA chain *and* the hostname, so only trusted certs can join.
- **`elasticsearch-certutil`** generates a CA then per-node certs (`certutil ca`, then `certutil cert --ca`); store the key as a PKCS#12 and reference it in `elasticsearch.yml`.
- **Verification modes** — `full` (chain + hostname), `certificate` (chain only, skips hostname), `none` (test-only). Dropping below `full` on transport reopens the rogue-node hole.
- **PKI auth** reuses the HTTP client cert as an authentication realm — the cert *is* the identity.

## Example

Minimal transport TLS block in `elasticsearch.yml`:

```
xpack.security.transport.ssl:
  enabled: true
  verification_mode: full
  keystore.path: certs/node.p12
  truststore.path: certs/node.p12
```

A node missing the CA in its truststore is rejected at the handshake — it never sees cluster state.

## Pitfalls

- **`verification_mode: certificate` on transport** — accepts *any* cert signed by the CA regardless of hostname; one mis-issued cert lets a rogue node in.
- **Self-signed cert with hostname mismatch** — clients fail with `PKIX path` / hostname errors; certs must list every node hostname/IP in SANs.
- **Forgetting cert expiry** — an expired node cert silently drops that node from the cluster at restart; track and rotate before expiry.
- **TLS on HTTP but not transport** — passwords are safe but inter-node traffic and rogue-join remain exposed; both layers must be secured.

## See also

- [[authentication-users]]
- [[cryptography-basics]]
