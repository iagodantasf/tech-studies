---
title: Security basics (authn/authz, encryption, rate limiting)
track: system-design
group: Security
tags: [system-design, security]
prerequisites: [cryptography-basics]
see-also: [api-gateway-routing-aggregation-offloading, circuit-breaker-retry-throttling-bulkhead]
---

# Security basics (authn/authz, encryption, rate limiting)

The four controls that gate every request: prove *who* you are, decide *what* you may do, keep the bytes unreadable on the wire and at rest, and cap how fast anyone can hammer you.

## Why it matters

These primitives are the floor under every other system-design decision — a flawless sharding scheme is worthless if anyone can read another tenant's data. They are also where the expensive incidents live: leaked credentials, broken object-level access, plaintext backups, and credential-stuffing floods. Most breaches are not exotic crypto breaks but misused basics, so getting these right is cheap insurance against the costliest failures.

## How it works

The controls compose in order on each request:

- **Authentication (authn)** — *who are you?* Verify a credential (password + MFA, an OAuth/OIDC token, an mTLS client cert) and mint a short-lived session/JWT. Never roll your own; lean on [[cryptography-basics]] for the signatures and hashes underneath.
- **Authorization (authz)** — *what may you do?* Check the authenticated principal against a policy (RBAC roles or ABAC attributes) **per resource**, not just at login.
- **Encryption in transit** — TLS (HTTPS) on every hop, including service-to-service, so a network tap sees ciphertext only.
- **Encryption at rest** — disk/DB/object-store encryption plus app-level encryption for the crown jewels (PII, tokens), keys held in a KMS/HSM and rotated.
- **Rate limiting** — cap requests per principal to blunt brute-force, scraping, and accidental retry storms; pairs naturally with [[circuit-breaker-retry-throttling-bulkhead]] and is often enforced at the [[api-gateway-routing-aggregation-offloading]].

| Concern | Question | Mechanism | Failure if skipped |
| --- | --- | --- | --- |
| Authn | Who are you? | Password+MFA, OIDC, mTLS | Impersonation |
| Authz | What may you do? | RBAC / ABAC per resource | Privilege escalation |
| In transit | Who can read it? | TLS 1.3 | Eavesdropping, MITM |
| At rest | Stolen disk? | KMS-backed encryption | Data dump on breach |
| Rate limit | How fast? | Token bucket per key | Brute force, scraping |

A token-bucket gate, evaluated before the handler runs:

```
on request(principal):
  bucket = store.get(principal)          # tokens refill at R/sec, cap B
  if bucket.take(1): forward to handler
  else: return 429 Too Many Requests, Retry-After: <secs>
```

## Example

A client calls `POST /transfers`. The gateway terminates TLS, validates the JWT signature and expiry (authn), then debits one token from that user's bucket — say 5 req/s; on empty it returns `429` with `Retry-After` and never reaches the service. With tokens left, the transfer service checks that *this* user owns the source account (authz, object-level), executes inside an encrypted-at-rest database, and logs the principal for audit. A stolen token still fails authz on accounts it doesn't own, and a credential-stuffing bot is throttled long before it can guess.

## Pitfalls

- **Authn without per-object authz** — checking the user is logged in but trusting a client-supplied `account_id`; the classic IDOR / broken-object-level-access bug.
- **Rate limiting only at the edge by IP** — one NAT'd office shares an IP; limit per API key or user, and protect login endpoints specifically.
- **Long-lived, un-revocable tokens** — a leaked 1-year JWT is a 1-year breach; keep access tokens short and use refresh + revocation.
- **"Encrypted at rest" but keys beside the data** — backups, logs, and KMS keys in the same blast radius means one compromise leaks everything.

## See also

- [[cryptography-basics]]
- [[api-gateway-routing-aggregation-offloading]]
- [[circuit-breaker-retry-throttling-bulkhead]]
