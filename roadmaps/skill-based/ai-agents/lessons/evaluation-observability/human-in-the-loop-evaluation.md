---
title: Human-in-the-loop Evaluation
track: ai-agents
group: Evaluation / Observability
tags: [ai-agents, human-eval]
prerequisites: [metrics-to-track]
see-also: [langsmith, safety-red-team-testing]
---

# Human-in-the-loop Evaluation

Using human judgment — ratings, pairwise preferences, or approvals — to score agent output on the subjective dimensions automated metrics can't capture.

## Why it matters

"Is this answer helpful, on-tone, and safe?" has no string match. Humans are the ground truth that calibrates cheaper proxies: you collect a few hundred human labels, then validate that an [[langsmith|LLM judge]] agrees with them before trusting the judge to scale. Human review is also the literal control surface for risky actions — a human approving a payment or an email send is HITL acting as both gate and evaluator.

## How it works

Two distinct modes, often confused: **evaluation** (offline, scoring quality) and **oversight** (inline, approving an action mid-[[agent-loop]]).

| Method | What annotators do | Best for |
|---|---|---|
| Direct rating | score 1–5 / thumbs | absolute quality tracking |
| Pairwise A/B | pick better of two | comparing model/prompt versions |
| Binary pass/fail | meets rubric? | regression gates |
| Approve / edit | accept or fix an action | inline oversight |

- **Pairwise beats Likert.** Humans rank two outputs far more consistently than they assign absolute scores; aggregate wins into an Elo or win-rate.
- **Rubrics + multiple raters.** A written rubric plus 2–3 raters per item, measuring inter-annotator agreement (Cohen's κ), turns vibes into a defensible number.
- **Inline gate.** Pause the run (LangGraph `interrupt`), surface the proposed tool call, resume on approval — this is [[langgraph]]'s human-in-the-loop pattern.
- **Calibrate the judge.** Use human labels as the gold set to measure whether an automated judge's verdicts correlate before replacing humans.

## Example

Shipping a new system prompt for a support agent:

```
sample 200 real conversations → run old vs new prompt
present blind A/B to 3 reviewers (rubric: correct, polite, complete)
  new wins 124, old wins 61, tie 15  → win-rate 67%
inter-rater κ = 0.71 (substantial agreement) → trust the result → ship
```

The 67% blind win-rate is decision-grade evidence; a raw "feels better" is not.

## Pitfalls

- **No rubric.** Without explicit criteria, raters drift and agreement collapses; ratings become noise.
- **Single annotator.** One person's bias becomes ground truth; use multiple and report κ.
- **Position/length bias.** Reviewers favor the first-shown or longer answer — randomize order, control for length.
- **Reviewing everything.** Human review doesn't scale to all traffic; sample, or gate only high-risk actions (see [[safety-red-team-testing]]).

## See also

- [[langsmith]]
- [[safety-red-team-testing]]
