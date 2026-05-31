---
title: Metrics to Track
track: ai-agents
group: Evaluation / Observability
tags: [ai-agents, metrics]
prerequisites: [agent-loop, token-based-pricing]
see-also: [structured-logging-tracing, langfuse]
---

# Metrics to Track

The small set of quality, cost, latency, and reliability numbers you instrument on every agent run so you can tell whether a change made things better or worse.

## Why it matters

Agents fail quietly: a prompt tweak that fixes one case silently regresses ten others, and you only find out from users. Without metrics you are flying blind on the three axes that matter — is it *correct*, is it *fast enough*, is it *affordable* — and you can't compare model A vs B or yesterday vs today. The point is to make every change falsifiable against a baseline.

## How it works

Group metrics by axis and track each per-step *and* per-task, because a cheap step inside a 30-step loop can still blow the budget.

| Axis | Metric | Why |
|---|---|---|
| Quality | task success rate | did it actually finish the goal |
| Quality | tool-call validity % | malformed/failed calls per run |
| Cost | tokens & $ per task | [[token-based-pricing]], not per call |
| Latency | p50 / p95 / p99 | tails kill UX, not the mean |
| Latency | time-to-first-token | streaming feel |
| Reliability | error / retry rate | API + tool failures |
| Loop | steps per task | drift / runaway detector |

- **Per-task aggregation.** One [[agent-loop]] = many model calls; roll cost and latency up to the task so a 6-call task shows as one $ number.
- **Percentiles, not averages.** A mean of 2s hides a p99 of 40s; always chart p95/p99.
- **Online vs offline.** Online = live traffic dashboards; offline = a frozen eval set scored in CI (see [[integration-testing-for-flows]]).
- **Quality needs a judge.** Success is rarely a string match — use a checker, an LLM judge, or [[human-in-the-loop-evaluation|human labels]].

## Example

A dashboard row for a [[rag-agent|RAG agent]] over 1,000 runs:

```
task success      82%   (target 90%)
tool-call valid   96%
steps/task p50/p95   4 / 11   ← p95 spike = looping
tokens/task        9.2k     $0.041/task
latency p50/p95    3.1s / 18s  ← investigate the 18s tail
```

The p95 of 11 steps flags runs where the loop never converges — invisible in the average of ~5.

## Pitfalls

- **Tracking averages only.** The mean looks fine while the p99 is on fire; users live in the tail.
- **Per-call cost, not per-task.** A "cheap" call × 30 loop iterations is an expensive task; aggregate up.
- **No baseline.** A 78% success rate is meaningless without last week's number to compare against.
- **Vanity metrics.** Total request count or token volume don't tell you if the agent *works*; anchor on success and cost-per-task.

## See also

- [[structured-logging-tracing]]
- [[langfuse]]
