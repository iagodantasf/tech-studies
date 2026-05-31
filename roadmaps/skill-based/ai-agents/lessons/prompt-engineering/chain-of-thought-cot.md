---
title: Chain of Thought (CoT)
track: ai-agents
group: Prompt Engineering
tags: [ai-agents, reasoning]
prerequisites: [be-specific-in-what-you-want]
see-also: [react-reason-act, reasoning-vs-standard-models]
---

# Chain of Thought (CoT)

Chain of Thought is prompting a model to emit intermediate reasoning steps before its final answer, trading extra tokens for higher accuracy on multi-step problems.

## Why it matters

A standard model commits to an answer in a single forward pass — fine for recall, but it collapses on arithmetic, logic, and multi-hop questions where the answer depends on a chain of sub-conclusions. CoT lets the model "use the page as scratch space," computing each step in the open so later tokens can attend to earlier work. It is the conceptual seed of agent [[reason-and-plan|planning]] and of [[react-reason-act|ReAct]], where reasoning interleaves with actions.

## How it works

Steer the model into stepwise generation:

| Variant | Trigger | When |
|---|---|---|
| Zero-shot CoT | "Let's think step by step." | quick, no examples on hand |
| Few-shot CoT | examples that *show* the reasoning | hardest tasks, need a pattern |
| Self-consistency | sample N chains, majority-vote answer | accuracy worth the token cost |

The mechanism is autoregressive: each step is conditioned on the ones before it, so the model effectively does more computation per answer. **Self-consistency** strengthens this — generate N independent chains at [[temperature]] > 0, then take the most common final answer; correct reasoning paths converge while errors scatter. Note that reasoning ("thinking") models — see [[reasoning-vs-standard-models]] — bake an extended CoT into a hidden scratchpad and are RL-trained to use it, so explicit "think step by step" adds little; CoT prompting matters most on *standard* models.

## Example

Same problem, with and without the reasoning prompt:

```
Q: A bat and ball cost $1.10. The bat costs $1 more
   than the ball. How much is the ball?

Direct:  "$0.10"                          # wrong (intuitive trap)

CoT: "Let ball = x. Bat = x + 1.
      x + (x + 1) = 1.10  →  2x = 0.10  →  x = 0.05.
      The ball costs $0.05."              # correct
```

The wrong answer is the *high-probability* one; forcing the algebra into the open flips it to correct.

## Pitfalls

- **Unfaithful rationales** — the printed reasoning can be a post-hoc story that doesn't reflect the real computation; don't treat it as a proof or an audit log.
- **Leaking scratch to users** — raw CoT exposes errors and can be verbose; strip it or request a separate final answer.
- **CoT on trivial tasks** — adds latency and token cost with no accuracy gain; reserve it for genuinely multi-step problems.
- **Double-prompting reasoning models** — forcing CoT on a model that already thinks internally wastes tokens and can degrade results.

## See also

- [[react-reason-act]]
- [[reasoning-vs-standard-models]]
