---
title: Helicone
track: ai-agents
group: Evaluation / Observability
tags: [ai-agents, observability]
prerequisites: [api-requests]
see-also: [langfuse, token-based-pricing]
---

# Helicone

An open-source LLM observability layer that works as a **proxy/gateway** — you change the base URL, and it logs every request with zero code changes — plus caching, rate limiting, and cost analytics.

## Why it matters

[[langsmith]] and [[langfuse]] need SDK instrumentation; Helicone's headline trick is **one-line integration** — point your OpenAI/Anthropic client at its endpoint and every call is captured. That low-friction proxy also becomes a control plane: it can **cache** identical requests, enforce per-user **rate limits and spend caps**, and retry failures, all without touching app logic. Great when you want logging and cost control fast.

## How it works

The proxy sits between your app and the provider; it forwards the request, streams the response back, and records both. An async-logging mode exists for those who won't route through a proxy.

| Capability | How |
|---|---|
| Logging | proxy records req/resp, tokens, cost, latency |
| Caching | hash request → serve stored response |
| Rate limit | per-key/user request & cost ceilings |
| Custom properties | tag rows by `user`, `session`, feature |

- **Integration.** Set `base_url` to Helicone's gateway and add `Helicone-Auth`; or use the async SDK/OTel path to avoid the proxy hop.
- **Caching.** Identical prompts return a cached response in ms at $0 — powerful for repeated dev/eval calls, dangerous for non-deterministic ones.
- **Custom properties.** Attach headers like `Helicone-Property-Session`; dashboards then segment cost and latency by those tags ([[metrics-to-track]]).
- **Gateway features.** Built-in retries, fallbacks across providers, and per-user budget enforcement live at the gateway, not in your code.

## Example

Add observability to an OpenAI call by changing the URL only:

```python
client = OpenAI(
    base_url="https://oai.helicone.ai/v1",
    default_headers={
        "Helicone-Auth": f"Bearer {HELICONE_KEY}",
        "Helicone-Property-Session": session_id,   # for segmentation
        "Helicone-Cache-Enabled": "true",          # cache identical calls
    })
# every request now logged, costed, and cacheable — no other changes
```

A dashboard then shows cost per session and cache hit-rate; a repeated eval suite can run near-free on cache hits.

## Pitfalls

- **Proxy as single point of failure.** Routing all traffic through a gateway adds a hop and a dependency; use fallbacks or the async logger for critical paths.
- **Caching nondeterministic calls.** Serving a cached answer for a high-[[temperature]] or time-sensitive prompt returns stale/wrong output — cache only idempotent requests.
- **Latency overhead.** The extra network hop adds milliseconds; measure it, and prefer async logging if it matters.
- **PII in logs.** The proxy sees every prompt; redact before sending and review data-retention settings ([[data-privacy-pii-redaction]]).

## See also

- [[langfuse]]
- [[token-based-pricing]]
