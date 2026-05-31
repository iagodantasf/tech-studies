---
title: Closed-Weight Models
track: ai-agents
group: LLM Fundamentals
tags: [ai-agents, hosted-llms]
prerequisites: [api-requests]
see-also: [open-weight-models, token-based-pricing]
---

# Closed-Weight Models

A closed-weight model is an LLM whose parameters are never released — you rent inference over an HTTP API (GPT-4o, Claude, Gemini) instead of running the weights yourself.

## Why it matters

For most agents the frontier of capability lives behind these APIs, so the default build is "call someone else's model." You trade control for capability and zero ops: no GPUs, no serving stack, instant access to the strongest reasoning and tool-use. The cost is real — per-token billing, vendor lock-in, rate limits, and data leaving your boundary — which is exactly why teams weigh them against [[open-weight-models]].

## How it works

You authenticate with an API key and POST a messages array; the provider runs the model on its own hardware and streams tokens back. You see behavior, not weights.

- **Versioned snapshots.** Endpoints pin a dated build (e.g. `gpt-4o-2024-08-06`); a silent `-latest` alias can shift behavior under you, so pin the date in production.
- **Server-side features** you don't implement: native [[llm-native-function-calling]], JSON/structured output, prompt caching, batch endpoints, content moderation.
- **Governance knobs** the vendor controls: rate limits (RPM/TPM), regional routing, retention windows, and a refusal/safety layer you cannot disable.

| Property | Closed-weight | Open-weight |
|---|---|---|
| Weights | private | downloadable |
| Hosting | vendor only | you or vendor |
| Marginal cost | per token | per GPU-hour |
| Fine-tune | hosted only, if offered | full control |
| Data path | leaves your boundary | can stay in-VPC |

## Example

A minimal Claude call — same shape across providers:

```
POST https://api.anthropic.com/v1/messages
headers: x-api-key, anthropic-version
body: { model: "claude-3-5-sonnet-20241022",
        max_tokens: 1024,
        messages: [{role:"user", content:"..."}] }
→ streamed tokens; billed input + output (see [[token-based-pricing]])
```

You never touch a checkpoint file — capability arrives as a network dependency.

## Pitfalls

- **Silent model drift.** Defaulting to a `-latest` alias means a vendor update can regress your evals overnight; pin dated snapshots and re-test on upgrade.
- **Data residency / training-on-input.** Confirm the API tier's retention and opt-out; consumer endpoints may train on prompts, enterprise ones usually don't.
- **Capacity as a SPOF.** A provider outage or 429 storm takes your whole agent down — add retries, timeouts, and a fallback model.
- **Lock-in via proprietary features.** Building on one vendor's assistant/tool format raises switching cost; keep a thin provider-agnostic adapter.

## See also

- [[open-weight-models]]
- [[token-based-pricing]]
