---
title: Remote / Cloud
track: ai-agents
group: Agent Deployment
tags: [ai-agents, deployment]
prerequisites: [acting-tool-invocation, rest-api-knowledge]
see-also: [local-desktop, structured-logging-tracing, token-based-pricing]
---

# Remote / Cloud

Running the agent loop on a server you operate, exposed over an API, so many users hit one centrally-managed, observable, horizontally-scaled deployment.

## How it works

The loop lives behind an HTTP endpoint. Because [[agent-loop]] runs are long and bursty, the hard parts are concurrency, state, and isolation — not the model call itself.

- **Stateless workers, external state** — keep the loop process stateless and stash session/[[short-term-memory]] in Redis or Postgres, so any worker can resume a run and you can scale pods independently.
- **Long-running jobs** — a multi-step run can take minutes; use async workers + a queue (or websockets/SSE for [[streamed-vs-unstreamed-responses]]) rather than a blocking request that hits a 30 s gateway timeout.
- **Per-tenant isolation** — tool execution (esp. [[code-execution-repl]]) runs in a per-request sandbox (container/microVM), never the app process, since you're running *other people's* prompts.
- **Centralized everything** — one place for [[structured-logging-tracing]], rate limits, key rotation, and prompt updates pushed to all users instantly.

## Why it matters

Cloud is the default for any multi-user product: you patch a prompt-injection hole or swap models once and everyone gets it, versus chasing stale installs in [[local-desktop]]. It's also where you *see* what the fleet does — traces, [[token-based-pricing]] cost per tenant, eval metrics — and where you enforce guardrails server-side instead of trusting a client.

## Example

A typical async request path:

```
POST /runs {goal} → 202 {run_id}        # enqueue, don't block
 worker: pop job → agent loop (N steps)
         each tool_use → spawn sandbox, run, collect obs
         stream tokens over SSE to client
 state → Redis: runs:<id> = {step, messages, cost}
GET /runs/<id> → status + partial output  # poll or resume
```

One model key, one trace backend, one rate limiter front everyone — N concurrent runs, no shared mutable state between them.

## Pitfalls

- **Gateway timeouts.** A synchronous endpoint dies on a 4-minute run; go async (202 + poll/stream) or the load balancer kills it mid-loop.
- **Runaway cost.** A looping agent can burn thousands of tokens per request; enforce a per-run step + token budget server-side, not just client-side (see [[max-length-max-tokens]]).
- **Cross-tenant leakage** — shared sandbox state, a cached vector index, or a mis-scoped DB query exposes one user's data to another; isolate per tenant.
- **Lost runs on deploy** — in-memory loop state vanishes when a pod restarts; externalize state so a rolling deploy or crash can resume, not drop, the job.

## See also

- [[local-desktop]]
- [[structured-logging-tracing]]
- [[token-based-pricing]]
