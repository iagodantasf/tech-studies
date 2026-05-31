---
title: Provide Additional Context
track: ai-agents
group: Prompt Engineering
tags: [ai-agents, prompt-design]
prerequisites: [context-windows]
see-also: [be-specific-in-what-you-want, embeddings-and-vector-search]
---

# Provide Additional Context

Context engineering is supplying the facts, examples, and constraints a model needs at inference time so it reasons over *your* reality instead of its training-data average.

## Why it matters

A model knows nothing about your codebase, your customer, or last week's incident — without that grounding it confabulates plausible-but-wrong answers. Supplying relevant context is the single highest-leverage move against hallucination, and it is the entire premise of [[rag-and-vector-databases|RAG]]: retrieve the right facts, paste them in, and let the model do the reasoning. In an agent, the [[observation-reflection]] output of one step becomes the context of the next.

## How it works

Layer context by stability — static at the top (cacheable), volatile near the question:

| Layer | Holds | Example |
|---|---|---|
| System / role | Persona, rules | "You are a SQL assistant" |
| Reference | Facts, docs, schema | table DDL, API spec |
| Few-shot | Input→output pairs | 2-3 worked examples |
| Query | The actual ask | "write the join for…" |

Two patterns dominate. **Few-shot prompting** shows 2-5 examples so the model infers the pattern — far more reliable than describing it. **Retrieval** ([[embeddings-and-vector-search]]) pulls only the top-k relevant chunks instead of dumping everything, because every token competes for the [[context-windows|window]] and models lose recall in the middle of long inputs ("lost in the middle"). Delimit injected context clearly (XML tags, `---`, triple backticks) so the model never confuses data for instructions — the same boundary that defends against [[prompt-injection-jailbreaks]].

## Example

Grounding a support bot with retrieved facts instead of trusting memory:

```
SYSTEM: Answer ONLY from <docs>. If absent, say "I don't know."

<docs>
Refund policy: digital goods refundable within 14 days of purchase.
Order #8821: purchased 2026-05-02, type=digital.
</docs>

USER: Can I refund order 8821?  (today: 2026-05-30)

→ "No — order #8821 was purchased on 2026-05-02, past the
   14-day window for digital goods."
```

Without the `<docs>` block the model guesses a generic policy; with it, the answer is correct and auditable.

## Pitfalls

- **Dumping everything** — stuffing the whole wiki buries the relevant chunk and triggers lost-in-the-middle recall loss; retrieve, don't paste.
- **Stale context** — pasted facts are a snapshot; an agent that caches them across turns will answer from outdated state.
- **No source boundary** — un-delimited context lets injected text ("ignore previous instructions") read as a command.
- **Contradictory layers** — a system rule fighting a few-shot example yields unpredictable precedence; keep them consistent.

## See also

- [[be-specific-in-what-you-want]]
- [[embeddings-and-vector-search]]
