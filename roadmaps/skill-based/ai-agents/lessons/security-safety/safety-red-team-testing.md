---
title: Safety / Red-Team Testing
track: ai-agents
group: Security / Safety
tags: [ai-agents, red-teaming]
prerequisites: [prompt-injection-jailbreaks, bias-toxicity-guardrails]
see-also: [data-privacy-pii-redaction, integration-testing-for-flows]
---

# Safety / Red-Team Testing

Deliberately attacking your own agent — with adversarial prompts, injected content, and edge cases — to find safety failures before users or attackers do, then locking each one down with a regression test.

## Why it matters

[[bias-toxicity-guardrails|Guardrails]] and prompts are claims; red-teaming is the evidence. Because LLMs are non-deterministic, a single passing demo proves nothing — you need adversarial coverage to know the failure rate. It turns "we have safety" into a measurable number (attack success rate) and converts every breach into a permanent test, so a model swap or prompt edit can't silently reopen a hole.

## How it works

Treat safety like a test suite: a corpus of attacks, an automated runner, a pass/fail judge, and a tracked metric. Mix manual creativity with automated scale.

- **Attack corpus** — jailbreaks, [[prompt-injection-jailbreaks|indirect injections]] in tool content, [[data-privacy-pii-redaction|PII]] exfil attempts, toxicity elicitation, and the agent's *specific* tool risks (can a prompt make it delete or spend?).
- **Automated red-teaming** — tools (Garak, PyRIT, promptfoo, [[deepeval|DeepEval]]) mutate seeds and run hundreds of variants; an LLM-judge or rule scores each outcome.
- **Metric** — **Attack Success Rate** = breaches / attempts. Track it per category over time; set a release gate (e.g. ASR < 1% on the known set).
- **Close the loop** — every successful attack becomes a fixed regression case + a guardrail update; re-run in CI on every prompt/model change.

| Stage | Output |
|---|---|
| Generate attacks | seed prompts × mutations |
| Run against agent | responses + tool calls |
| Judge | pass / fail per attempt |
| Report | ASR by category |
| Regress | failures pinned in CI |

## Example

```
suite: injection (50), jailbreak (40), pii-exfil (20), toxicity (30)
run vs agent-v0.4:
  injection   3/50  fail  → ASR 6.0%   ← over gate (1%)
  jailbreak   0/40        → 0%
  pii-exfil   1/20  fail  → 5.0%
fix: add egress allow-list + tighten tool scope
rerun → injection 0/50, pii 0/20 → ship; 4 cases pinned in CI
```

The 4 breaches become permanent tests; a later model upgrade that reintroduces one fails the build.

## Pitfalls

- **One run isn't a result.** Non-determinism means you must run each attack n times (sampling) and report a rate, not a single pass.
- **Stale corpus.** New jailbreaks appear weekly; a frozen attack set rots — refresh it and add every real incident.
- **Judging is hard.** An LLM-judge can mislabel a refusal as a breach (or miss a subtle one); spot-check the judge against human labels.
- **Testing the model, not the agent.** Safety lives in the *whole loop* — tools, retrieval, egress. Red-team end-to-end behavior (see [[integration-testing-for-flows]]), not just the bare model.

## See also

- [[data-privacy-pii-redaction]]
- [[integration-testing-for-flows]]
