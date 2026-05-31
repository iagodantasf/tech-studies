---
title: Perception / User Input
track: ai-agents
group: What are AI Agents
tags: [ai-agents, perception]
prerequisites: [agent-loop]
see-also: [provide-additional-context, short-term-memory]
---

# Perception / User Input

Perception is how an agent ingests its world each turn — the user request plus any retrieved context, tool outputs, and state — and packs it into the model's input.

## Why it matters

The model only knows what's in its context window; perception decides what makes it in. A perfect reasoning model fails if the relevant fact was never shown, or if the input is so noisy the signal is buried. In practice most "the agent is dumb" complaints trace to bad perception: missing context, stale memory, or a raw 50KB tool dump that drowns the actual question.

## How it works

Perception assembles a structured prompt from several sources, then orders and trims it to fit the [[context-windows|window]]:

| Source | Example | Freshness |
|---|---|---|
| User input | "summarize this PR" | per turn |
| System/instructions | role, rules, tool list | static |
| Retrieved context | RAG hits, docs | per query |
| Prior state | [[short-term-memory]], scratchpad | accumulating |

- **Normalize** heterogeneous input — PDFs, HTML, images — into clean text or typed blocks before the model sees it; strip boilerplate and nav chrome from scraped pages.
- **Order matters**: instructions and the live question belong where the model attends most; many models weakly favor the start and end, so don't bury the ask in the middle.
- Treat all user/tool text as untrusted — perception is the entry point for [[prompt-injection-jailbreaks]], so keep instructions and data clearly delimited.
- Multimodal perception (image/audio) is just more input blocks, but each carries a real token cost — an image can run hundreds to ~1k+ tokens.

## Example

A support agent gets "my last order is late". Perception expands this into: system rules + the user line + a retrieved order record (`#4471, shipped, ETA +2d`) + the last 3 turns of [[short-term-memory]]. The model never "looked up" the order — perception fetched and injected it, framed as data, so the model can answer without guessing the order ID.

## Pitfalls

- **Context stuffing** — dumping whole documents instead of the relevant span raises cost and lowers accuracy via distraction.
- **Lost-in-the-middle** — critical facts placed mid-prompt get under-weighted; surface them near the edges.
- **Trusting input** — un-delimited tool/web text can carry injected instructions the model then obeys.
- **No normalization** — feeding raw HTML/whitespace wastes tokens and confuses extraction.

## See also

- [[provide-additional-context]]
- [[short-term-memory]]
