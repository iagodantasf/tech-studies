---
title: Task queues
track: system-design
group: Asynchronism
tags: [system-design, background-jobs]
prerequisites: [message-queues]
see-also: [back-pressure, idempotent-operations]
---

# Task queues

A task queue runs units of work (jobs) in the background on a pool of workers, off the request path, with scheduling, retries, and result tracking built in.

## Why it matters

Anything slow or flaky — sending email, resizing images, generating a PDF, calling a third-party API — should not run inside the user's HTTP request. A task queue moves it to a worker pool so the web tier responds in milliseconds and stays responsive under load. It layers job-level features on top of a raw broker: retries with backoff, scheduled/periodic execution (cron), priorities, and a place to store results — things you'd otherwise hand-roll on a bare [[message-queues|message queue]].

## How it works

A web process **enqueues** a task (function name + arguments, serialized); **workers** pull and execute. Frameworks like Celery, Sidekiq, and Resque add operational machinery on top:

| Feature | What it gives you |
|---|---|
| Retry + backoff | re-run failed jobs after 1s, 4s, 16s… |
| Scheduled / periodic | run at a time, or every N minutes (beat) |
| Priorities | drain `critical` before `low` |
| Result backend | store return value / status by job id |

The flow:

```
enqueue("resize_image", {photo_id: 42}) → broker
worker: deserialize → run → on error, retry w/ backoff → DLQ after N
```

A task queue *uses* a broker (Redis, RabbitMQ) for transport but owns the job lifecycle. Keep tasks small, [[idempotent-operations|idempotent]] (retries re-run them), and pass **ids, not payloads** — fetch fresh data inside the worker so a job sitting in the queue never carries stale state. When producers outpace workers, apply [[back-pressure]] rather than letting the queue grow without bound.

## Example

User uploads a profile photo:

```
POST /avatar  → save original to S3
              → enqueue("make_thumbnails", {photo_id: 42})
              → return 202 Accepted immediately

worker pool (×8):
  load photo 42 → generate 64/128/512px → write to S3 → mark done
  on transient S3 error → retry (backoff); 5 fails → DLQ + alert
```

The user sees "processing…" and the UI swaps in thumbnails when the job finishes — the request itself returned in ~20 ms.

## Pitfalls

- **Fat payloads.** Serializing whole objects into the job bloats the broker and goes stale; enqueue an id and re-read inside the task.
- **Non-idempotent jobs.** With at-least-once execution, a retried "charge card" job double-charges unless guarded by an idempotency key.
- **Silent failures.** Without DLQ monitoring and alerts, jobs vanish; track failure rate, queue latency, and DLQ depth.
- **Long-running tasks blocking workers.** One 10-minute job ties up a worker; chunk big work into many small tasks so the pool stays liquid.

## See also

- [[message-queues]]
- [[back-pressure]]
