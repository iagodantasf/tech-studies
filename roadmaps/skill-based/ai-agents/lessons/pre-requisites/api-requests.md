---
title: API Requests
track: ai-agents
group: Pre-requisites
tags: [ai-agents, http-client]
prerequisites: [rest-api-knowledge]
see-also: [basic-backend-development, streamed-vs-unstreamed-responses]
---

# API Requests

The client-side mechanics of actually *making* an HTTP call from code — headers, JSON bodies, timeouts, retries, and streaming — which is the literal substrate of both model calls and tool use.

## Why it matters

An agent does almost nothing but make API requests in a loop: one to the model, then several to tools, then back to the model. The robustness of that loop is the robustness of your request code. Naive `requests.get(url)` with no timeout is the single most common reason an agent hangs forever on one bad call.

## How it works

A request has four moving parts you control: **method**, **URL + query**, **headers** (auth, content-type), and **body** (usually JSON). The response gives you a status, headers, and a body you parse.

Production request code wraps four behaviors around the raw call:

- **Timeouts** — always set connect *and* read timeouts; model calls need a long read timeout (30-120s) but a short connect timeout (~5s).
- **Retry with backoff + jitter** — on `429`/`5xx`, sleep `base * 2^attempt + random`, cap attempts (e.g. 4) to avoid retry storms.
- **Streaming** — for model responses, read the body incrementally (SSE / chunked) so you can show tokens as they arrive; see [[streamed-vs-unstreamed-responses]].
- **Connection reuse** — use one `Session`/client so TCP+TLS handshakes are pooled, not re-paid per call (see [[networking]]).

Async matters here: an agent often fans out to several tools at once, so `asyncio.gather` over an async client turns 5 sequential 1s calls into one 1s wall-clock step.

## Example

```python
import httpx, random, asyncio

async def call(client, url, payload, attempts=4):
    for i in range(attempts):
        r = await client.post(url, json=payload,
                               timeout=httpx.Timeout(connect=5, read=60))
        if r.status_code < 400:
            return r.json()
        if r.status_code in (429, 500, 502, 503):
            await asyncio.sleep(2 ** i + random.random())   # backoff + jitter
            continue
        r.raise_for_status()        # 4xx (not 429): don't retry, surface it
    raise RuntimeError("exhausted retries")
```

## Pitfalls

- **No timeout at all** — the default in many clients is *infinite*; one stalled tool call freezes the whole agent turn.
- **Retrying inside a retrying caller** — nested retry layers multiply (4 x 4 = 16 calls); own retries at exactly one layer.
- **Buffering a streamed response** — calling `.json()` on a streaming endpoint blocks until the full generation finishes, killing the latency win.

## See also

- [[basic-backend-development]]
- [[streamed-vs-unstreamed-responses]]
