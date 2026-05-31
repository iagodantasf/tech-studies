---
title: Pricing & Token Usage
track: claude-code
group: Getting started
tags: [claude-code, cost]
prerequisites: [choosing-a-model]
see-also: [authentication-api-keys, managing-context-clear-compact, cost-context-optimization]
---

# Pricing & Token Usage

Claude Code bills by **tokens** — input plus output — so cost tracks how much context the model reads and how much it writes, scaled by the model tier.

## Why it matters

On API-key billing, a careless session can read an entire repo into context on every turn and quietly cost real money; on a subscription it instead burns toward your usage limit. Either way, tokens are the currency. Understanding what fills the window — files, tool output, conversation history — is what lets you keep an agentic loop affordable instead of watching cost climb turn over turn.

## How it works

Two billing models, both ultimately about tokens:

| Plan | You pay | Token effect |
|---|---|---|
| Subscription (Pro/Max) | flat monthly fee | usage counts toward a periodic limit |
| API key | per-token, per-model | direct $ per input + output token |

- **Input tokens** = everything sent up: your prompt, [[claude-md-project-memory|CLAUDE.md]], every Read file, and all prior turns. **Output tokens** = what Claude writes (text + tool calls), usually priced higher.
- Cost roughly scales **per turn with total context size** — a 100k-token window re-billed each turn dominates the bill, so a long thread is expensive even if your last message was short.
- **Prompt caching** discounts repeated context (e.g. unchanged system/CLAUDE.md across turns) — a major saver the tool leverages automatically.
- `/cost` reports the running token/spend for the session; `/status` shows the model whose rates apply (see [[choosing-a-model]]).
- Larger tiers cost more per token: Opus > Sonnet > Haiku — model choice multiplies the bill.

## Example

Why a long session costs more than it looks:

```text
Turn 1:  prompt 500 + CLAUDE.md 1.5k + file 8k          ≈ 10k input
Turn 8:  same files still in context + 7 turns of history ≈ 60k input
         → each later turn re-bills the whole window
```

Running `/clear` between unrelated tasks resets that window to near-zero; `/compact` shrinks a long thread by summarizing it — both directly cut input tokens (see [[managing-context-clear-compact]]).

## Pitfalls

- **Treating it like a flat-fee chatbot on API billing.** Cost is proportional to context per turn; a huge window re-read every turn is the usual budget surprise.
- **Never clearing context.** Letting one session run all day means every late turn pays for hours of irrelevant history.
- **Reading whole big files.** Pulling a 5k-line file into context for a 3-line fix is pure waste — scope with [[claudeignore-file-scoping]] and targeted reads.
- **Ignoring output cost.** Asking for the full rewritten file instead of a diff inflates the (pricier) output token count.

## See also

- [[authentication-api-keys]]
- [[managing-context-clear-compact]]
- [[cost-context-optimization]]
