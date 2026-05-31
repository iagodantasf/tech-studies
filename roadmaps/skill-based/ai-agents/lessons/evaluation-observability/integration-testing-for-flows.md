---
title: Integration Testing for Flows
track: ai-agents
group: Evaluation / Observability
tags: [ai-agents, integration-testing]
prerequisites: [unit-testing, agent-loop]
see-also: [deepeval, metrics-to-track]
---

# Integration Testing for Flows

Testing a whole agent run end-to-end — perception → reason → tools → final answer — against a frozen scenario set, verifying the *flow* reaches the right outcome, not just that one function works.

## Why it matters

[[unit-testing|Unit tests]] prove the parser and each tool work in isolation, but agents fail in the *seams*: the model picks the wrong tool, mis-threads a result, or loops. Integration tests run the full [[agent-loop]] on realistic scenarios and assert on the trajectory and end state — the only way to catch "every part works but the agent still can't book the flight". They are your regression net: a prompt change that breaks step ordering shows up here, nowhere else.

## How it works

Run the real agent against a curated scenario set with **mocked external boundaries** (deterministic tools, recorded APIs) and assert on outcome *and* path.

| Assert on | Example check |
|---|---|
| Final outcome | answer matches / DB row created |
| Trajectory | called `search` before `book` |
| Tool calls | exactly one `send_email`, valid args |
| Budget | ≤ N steps, ≤ M tokens |
| Safety | never called `delete` without confirm |

- **Mock the boundaries, keep the brain.** Stub tools/APIs to fixed responses so failures are the agent's fault, not a flaky network; the LLM call stays real (or replayed).
- **Trajectory matters.** A right answer via a wrong path (skipped auth, deleted data) is a failed test — assert on the sequence of tool calls, not only the output.
- **Handle nondeterminism.** Pin [[temperature]]=0, seed where possible, and assert with fuzzy/[[deepeval|metric-based]] checks; run flaky cases N times and require a pass rate.
- **Golden scenarios from prod.** Promote real failure traces (via [[structured-logging-tracing]]) into permanent test cases.

## Example

A pytest-style flow test for a booking agent:

```python
def test_books_cheapest_flight():
    agent = build_agent(tools=mocked_flight_api)     # deterministic stubs
    result = agent.run("Book the cheapest SF→NYC flight Friday")

    assert "search_flights" in result.tool_sequence
    assert result.tool_sequence.index("search_flights") \
         < result.tool_sequence.index("book_flight")   # search before book
    assert result.booked["price"] == 214               # picked cheapest
    assert result.steps <= 8                            # didn't loop
```

A prompt change that makes the agent book before comparing prices fails this immediately.

## Pitfalls

- **Asserting only the final answer.** Misses dangerous paths (booked before confirming, skipped a safety check); test the trajectory too.
- **Live external calls.** Real APIs make tests flaky and slow and can incur side effects; mock or record/replay the boundary.
- **Brittle exact-match on text.** LLM phrasing varies; assert on structure/facts or metric thresholds, not full-string equality.
- **No budget assertions.** A test that passes but takes 40 steps hides a looping regression; cap steps/tokens ([[metrics-to-track]]).

## See also

- [[unit-testing]]
- [[deepeval]]
