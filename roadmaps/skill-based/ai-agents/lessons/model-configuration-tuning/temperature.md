---
title: Temperature
track: ai-agents
group: Model Configuration / Tuning
tags: [ai-agents, sampling]
prerequisites: []
see-also: [top-p-top-k, reason-and-plan]
---

# Temperature

Temperature is a scalar that scales the model's logits before softmax, controlling how sharp or flat the next-token probability distribution is — and thus how random the output gets.

## Why it matters

It is the single biggest knob between *deterministic, reproducible* and *creative, diverse* generation. Agents that call [[acting-tool-invocation|tools]] or emit JSON want low temperature so the structure is stable; a brainstorming or NPC-dialogue node wants it high so outputs don't collapse to one phrasing. Pick wrong and you either get rigid, repetitive text or malformed tool calls.

## How it works

Each logit `z_i` is divided by `T` before softmax: `p_i = softmax(z_i / T)`.

- `T → 0` — the distribution spikes toward the single highest logit (greedy/argmax). Near-deterministic.
- `T = 1` — the model's raw, untempered probabilities.
- `T > 1` — logits flatten, low-probability tokens gain mass, output gets wilder and eventually incoherent.

| T | Effect | Typical use |
|---|---|---|
| 0.0–0.3 | Sharp, near-greedy | Tool calls, extraction, code, [[react-reason-act]] steps |
| 0.7–0.9 | Balanced | Chat, drafting |
| 1.0–1.5 | Flat, diverse | Brainstorm, fiction, [[npc-game-ai]] |

Temperature and [[top-p-top-k|top-p]] compose: temperature reshapes the curve, then top-p/top-k truncate its tail. Most providers apply temperature *first*. Note `T=0` is "as close to greedy as the API allows" — not a true determinism guarantee.

## Example

Logits for three tokens: `[2.0, 1.0, 0.1]`.

```
T = 1.0 → softmax = [0.65, 0.24, 0.11]
T = 0.5 → softmax = [0.85, 0.12, 0.02]   # sharper, top token dominates
T = 2.0 → softmax = [0.46, 0.28, 0.18]   # flatter, tail gains mass
```

## Pitfalls

- **T=0 is not reproducible** — GPU non-determinism, batching, and MoE routing still cause drift across calls and model versions.
- **Stacking with top-p** — setting both aggressively low (`T=0.2`, `top_p=0.5`) over-truncates; tune one, leave the other near default.
- **High T over a long horizon** — small per-token randomness compounds across an [[agent-loop]], so a multi-step agent can wander off task far more than a single completion suggests.

## See also

- [[top-p-top-k]]
- [[max-length-max-tokens]]
