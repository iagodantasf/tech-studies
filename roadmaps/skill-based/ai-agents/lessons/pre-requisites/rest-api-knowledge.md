---
title: REST API Knowledge
track: ai-agents
group: Pre-requisites
tags: [ai-agents, rest]
prerequisites: [basic-backend-development]
see-also: [api-requests, networking]
---

# REST API Knowledge

REST is the request/response convention — resources, HTTP verbs, status codes, JSON — that nearly every model provider and tool an agent calls is built on.

## Why it matters

Every external action an agent takes is an HTTP call: the model API, [[web-search|search]], a CRM, your own [[database-queries|database]] service. Reading API docs fluently — knowing what a `429` means, why a `PUT` is safe to retry but a `POST` may not be — is the difference between a robust [[acting-tool-invocation|tool layer]] and one that silently corrupts data on every retry.

## How it works

A REST endpoint names a **resource** (`/v1/messages`) and acts on it with an HTTP **verb**:

| Verb | Meaning | Idempotent? |
|---|---|---|
| GET | Read | yes |
| POST | Create / invoke | no |
| PUT | Replace | yes |
| PATCH | Partial update | no |
| DELETE | Remove | yes |

**Status codes** carry the outcome, and your retry logic branches on them:

- `2xx` success; `200` OK, `201` created.
- `4xx` you sent a bad request — `400` malformed, `401/403` auth, `404` missing, `429` rate-limited. Don't blindly retry `4xx` except `429`.
- `5xx` the server failed — `500/502/503`. Safe to retry with backoff.

Auth is usually a bearer token in a header (`Authorization: Bearer sk-...`); bodies and responses are JSON. Providers signal rate limits via `429` plus a `Retry-After` header — the single most important code for an agent that fires many calls.

## Example

```http
POST /v1/messages HTTP/1.1
Host: api.anthropic.com
Authorization: Bearer sk-ant-...
Content-Type: application/json

{"model": "claude-...", "max_tokens": 1024, "messages": [...]}

→ 429 Too Many Requests
  Retry-After: 2          # wait 2s, then retry — do NOT hammer
```

## Pitfalls

- **Retrying non-idempotent calls blindly** — auto-retrying a `POST` that timed out can create two records or send two messages; use an idempotency key.
- **Ignoring `Retry-After`** — backing off a fixed 1s while the server says 30 just earns more `429`s; honor the header.
- **Treating any `2xx` as full success** — a `200` can still wrap an application-level error in its JSON body; check both layers.

## See also

- [[api-requests]]
- [[networking]]
