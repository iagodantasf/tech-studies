---
title: Bias / Toxicity Guardrails
track: ai-agents
group: Security / Safety
tags: [ai-agents, guardrails]
prerequisites: [acting-tool-invocation]
see-also: [safety-red-team-testing, prompt-injection-jailbreaks]
---

# Bias / Toxicity Guardrails

Runtime filters that sit on the agent's input and output to block disallowed content — hate, harassment, self-harm, illegal advice — and to catch biased or unfair responses before a user sees them.

## Why it matters

A base model will happily produce toxic or skewed output given the right prompt; alignment training reduces this but does not guarantee it, and your brand owns whatever ships. Guardrails are the deterministic safety net *outside* the model: they enforce policy you can audit and version, independent of which model or prompt is live. They also catch the long tail RLHF misses and give you a logged, blockable boundary for compliance.

## How it works

Two checkpoints — an **input guard** and an **output guard** — wrap the [[agent-loop]]. Each can allow, block, or rewrite.

- **Classifier-based** — a dedicated safety model scores categories (Llama Guard, OpenAI moderation, Azure Content Safety) with per-category severity; cheap and fast (~tens of ms).
- **Rules / lexicons** — regex and banned-term lists for crisp, deterministic cases (slurs, competitor names); zero false-negatives on what they cover, brittle on paraphrase.
- **LLM-as-judge** — a second model checks nuanced policy ("is this medical advice?"); flexible but slower and itself fallible.
- **On a hit** — block with a safe refusal, *or* rewrite/soften, *or* route to a human. Log every decision for tuning the threshold.

| Layer | Latency | Catches | Weakness |
|---|---|---|---|
| Lexicon / regex | ~1 ms | exact terms | trivial to paraphrase |
| Classifier model | ~30 ms | broad categories | fixed taxonomy |
| LLM judge | ~300 ms+ | nuanced policy | cost, own errors |

Bias is the harder half: it's *statistical*, not a banned word — measure it offline (refusal/sentiment rates across demographic-swapped prompts) and tune, since no single response is obviously "biased".

## Example

```
output guard, threshold = 0.7
model → "People from <group> are usually..."
moderation: {harassment: 0.81, hate: 0.66}
0.81 ≥ 0.7 → BLOCK
user sees: "I can't help with generalizations about groups."
log: {hit: harassment, score: .81, turn_id, prompt_hash}
```

The toxic completion was generated but never delivered; the block is logged for audit and threshold tuning.

## Pitfalls

- **Output-only guarding.** A clean prompt can still elicit toxicity, and a toxic prompt poisons the loop — guard both ends.
- **Threshold theatre.** Too strict over-refuses benign queries (hurts UX); too loose leaks. Pick per-category thresholds from labeled data, don't eyeball one global number.
- **Guardrails ≠ bias-free.** Toxicity filters miss subtle, fluent bias; bias needs separate offline evaluation across protected attributes.
- **Multilingual / obfuscation gaps.** Many filters are English-first and fooled by leetspeak or code-switching; test the languages and tricks you'll actually see (see [[safety-red-team-testing]]).

## See also

- [[safety-red-team-testing]]
- [[prompt-injection-jailbreaks]]
