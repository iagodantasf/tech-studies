---
title: Basic Backend Development
track: ai-agents
group: Pre-requisites
tags: [ai-agents, backend]
prerequisites: []
see-also: [rest-api-knowledge, databases]
---

# Basic Backend Development

The server-side skills — handling requests, talking to data stores, managing secrets and state — that an agent needs because an agent *is* a backend service that happens to call an LLM.

## Why it matters

An agent loop runs somewhere: it receives input, calls model and tool APIs, persists [[short-term-memory|memory]], and returns a response. That "somewhere" is a backend. Long model calls (5-60s), streaming, retries, and per-user secrets are all backend concerns, and getting them wrong shows up as dropped sessions, leaked API keys, or a $400 bill from a retry storm.

## How it works

A typical agent service is a thin HTTP layer over the loop:

| Concern | Why the agent needs it | Typical tool |
|---|---|---|
| Request handling | Accept user turns, stream tokens back | FastAPI, Express |
| Persistence | Conversation and memory state | Postgres, Redis |
| Secrets | Per-tenant model/tool keys | env vars, vault |
| Background work | Long tool calls, async jobs | queue, worker |

Key shifts from a normal CRUD backend:

- **Latency budget is huge** — a single turn may block on the model for tens of seconds, so synchronous request/response with a 30s gateway timeout breaks; use streaming or async jobs.
- **State lives outside the process** — keep the loop stateless and push conversation/memory to a [[databases|store]] keyed by session, so any worker can resume a turn.
- **Idempotency and retries** — model/tool calls fail transiently; wrap them in retry-with-backoff, but make tool side effects idempotent or you double-send the email.

## Example

```python
# Minimal agent endpoint (FastAPI), streaming model output
@app.post("/chat/{session_id}")
async def chat(session_id: str, msg: Msg):
    history = await store.load(session_id)      # state lives in the DB
    history.append({"role": "user", "content": msg.text})

    async def gen():
        async for chunk in run_agent_loop(history):   # may run 10-30s
            yield chunk                                # stream tokens out
        await store.save(session_id, history)          # persist after turn

    return StreamingResponse(gen(), media_type="text/event-stream")
```

## Pitfalls

- **Blocking the event loop** — a synchronous `requests.post` to the model stalls every other request on an async server; use the async client or a thread pool.
- **Hardcoding one API key** — fine for a demo, fatal for multi-tenant; scope keys per user and never log them.
- **No timeout/circuit breaker on tools** — one hung [[web-scraping-crawling|scrape]] pins a worker forever; bound every outbound call.

## See also

- [[rest-api-knowledge]]
- [[databases]]
