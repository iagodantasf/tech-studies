---
title: Async request-reply
track: system-design
group: Asynchronism
tags: [system-design, api-design]
prerequisites: [http]
see-also: [message-queues, rest-graphql]
---

# Async request-reply

Async request-reply is an HTTP pattern where a slow operation returns immediately with a handle the client polls (or gets called back on), decoupling the request from the long-running work behind it.

## Why it matters

Some operations are inherently slow — a video transcode, a bulk export, a report that takes minutes. Holding an HTTP connection open that long is fragile: load balancers and proxies kill idle requests (often at 30–60s), retries duplicate work, and a held thread is a wasted resource. Async request-reply lets the server accept the job, free the connection, and let the client check back — giving a clean, timeout-proof contract for work that can't finish within a normal request window.

## How it works

The server returns **202 Accepted** with a `Location` header pointing at a status resource the client polls until the result is ready:

| Step | Request | Response |
|---|---|---|
| 1. Submit | `POST /reports` | `202`, `Location: /reports/abc/status` |
| 2. Poll | `GET /reports/abc/status` | `200` running, or `303` → result |
| 3. Fetch | `GET /reports/abc` | `200` + the finished report |

Behind the 202, the work goes onto a [[message-queues|queue]] or [[task-queues|task queue]] for a worker to process. Use **`Retry-After`** on the status response to pace the client's polling and avoid a tight loop. For lower latency or many waiters, replace polling with a **webhook** callback or a WebSocket/SSE push. The status endpoint should be cheap and [[idempotent-operations|idempotent]] — it's read far more often than the submit. This is the HTTP-facing complement to the internal async machinery in [[rest-graphql|your API design]].

## Example

Bulk CSV export of a large account:

```
POST /exports        → 202  Location: /exports/9f/status
                              (job enqueued for a worker)

GET /exports/9f/status → 200 {"status":"running"}   Retry-After: 5
   ... worker finishes, writes file to S3 ...
GET /exports/9f/status → 303  Location: /exports/9f
GET /exports/9f        → 200  (presigned download URL)
```

The submit returns in ~15 ms; the client polls every 5s and never holds a connection through the multi-minute export — no gateway timeout, no duplicate jobs.

## Pitfalls

- **Tight polling loops.** Clients hammering the status URL every 100ms create needless load; enforce `Retry-After` and consider webhooks for fan-out.
- **Non-idempotent submit.** A retried `POST` that creates a second job duplicates the work; key the request so resubmits return the same job id.
- **Losing the handle.** If a job id isn't durable, a client crash strands the result; persist status server-side with a TTL the client can rely on.
- **No terminal/error state.** Status must eventually report `failed` with a reason, or clients poll forever on a job that already died.

## See also

- [[message-queues]]
- [[task-queues]]
