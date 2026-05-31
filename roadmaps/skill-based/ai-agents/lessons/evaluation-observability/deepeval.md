---
title: DeepEval
track: ai-agents
group: Evaluation / Observability
tags: [ai-agents, eval-framework]
prerequisites: [unit-testing]
see-also: [ragas, integration-testing-for-flows]
---

# DeepEval

An open-source LLM evaluation framework that feels like **Pytest for LLM output** — you write `assert`-style test cases with metrics like faithfulness, relevancy, and hallucination.

## Why it matters

Standard [[unit-testing]] asserts exact equality, which is useless for non-deterministic text. DeepEval gives you *fuzzy*, metric-based assertions that still run in CI: instead of `assert out == expected`, you assert `AnswerRelevancyMetric ≥ 0.7`. Because it integrates with Pytest, LLM quality checks live alongside normal tests and fail the build on regression — turning "vibes" into a gate.

## How it works

The unit is a **test case** (`input`, `actual_output`, optional `expected_output` and `retrieval_context`); you score it with one or more **metrics**, most of them LLM-as-judge with a threshold.

| Metric | Asks |
|---|---|
| AnswerRelevancy | does the output address the input? |
| Faithfulness | is it grounded in `retrieval_context`? |
| Hallucination | does it contradict the context? |
| ContextualPrecision | are retrieved chunks relevant/ranked? |
| GEval | custom rubric, your own criteria |

- **G-Eval.** Define a metric in plain English ("penalize answers that invent prices"); it uses chain-of-thought judging to produce a 0–1 score — the escape hatch for bespoke criteria.
- **Pytest-native.** `assert_test(case, [metric])` raises on failure; run with `deepeval test run` for a report, or plain `pytest`.
- **RAG-aware.** Faithfulness/precision/recall need `retrieval_context`, making it strong for a [[rag-agent]] (overlaps with [[ragas]]).
- **Judge model matters.** Metrics call an LLM (default GPT-class); the judge's quality and cost are part of your eval budget.

## Example

A grounding regression test in CI:

```python
from deepeval import assert_test
from deepeval.metrics import FaithfulnessMetric
from deepeval.test_case import LLMTestCase

def test_no_hallucination():
    case = LLMTestCase(
        input="What is the refund window?",
        actual_output=agent("What is the refund window?"),
        retrieval_context=["Refunds accepted within 30 days."])
    assert_test(case, [FaithfulnessMetric(threshold=0.8)])
# fails the build if the answer isn't grounded in the context
```

## Pitfalls

- **Threshold cargo-culting.** A `0.7` cutoff is arbitrary; calibrate against [[human-in-the-loop-evaluation|human labels]] before trusting it as a gate.
- **Flaky judges.** LLM-judge scores vary run-to-run; pin the judge model, set its temperature to 0, and expect some noise.
- **Eval cost.** Each metric is an extra LLM call — a large suite × several metrics can be slow and pricey; sample or run nightly.
- **No retrieval_context.** Faithfulness silently degrades without the grounding text supplied; pass it for RAG cases.

## See also

- [[ragas]]
- [[integration-testing-for-flows]]
