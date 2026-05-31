---
title: Unit Testing
track: ai-agents
group: Evaluation / Observability
tags: [ai-agents, unit-testing]
prerequisites: []
see-also: [integration-testing-for-flows, deepeval]
---

# Unit Testing

Testing the **deterministic** pieces around the model in isolation — tool functions, schema parsing, prompt builders, output validators — with classic fast, exact-match assertions.

## Why it matters

Most of an agent is ordinary code, and it should be tested like ordinary code. The model is nondeterministic, but the `parse_tool_args`, the `calculator` tool, and the JSON-schema validator are not — they have one right answer and belong in a fast unit suite. Pushing every check into slow, flaky [[integration-testing-for-flows|end-to-end flow tests]] is a classic anti-pattern; unit tests catch the boring 80% of bugs in milliseconds.

## How it works

Identify the deterministic surface, isolate it, and assert exact behavior. Mock the LLM so no network call happens.

| Test target | Assertion |
|---|---|
| Tool function | `add(2,3) == 5`, errors raise |
| Arg parsing | bad JSON → handled, not crash |
| Output validator | rejects malformed schema |
| Prompt builder | renders expected string |
| Router (mock LLM) | tool name → correct dispatch |

- **Mock the model.** Replace the LLM client with a stub returning a fixed `tool_use`/JSON, so you test *your* dispatch and parsing logic deterministically — no tokens, no flakiness.
- **Test the tools directly.** A [[database-queries|DB]] or API tool is just a function; unit-test its happy path, error path, and validation independently of any agent.
- **Validate structured output.** Assert the parser accepts good payloads and *rejects* malformed ones — the guard that stops a bad model response crashing the loop.
- **Fast and hermetic.** No network, runs in CI on every commit; this is where [[git-and-terminal-usage|the test suite]] gives instant feedback.

## Example

Unit-testing the dispatch layer with a stubbed model:

```python
def test_router_dispatches_to_calculator():
    fake_llm = Stub(returns={"tool":"calculator","args":{"expr":"2+2"}})
    agent = Agent(llm=fake_llm, tools={"calculator": calc})

    out = agent.step("what is 2+2")
    assert out.tool_called == "calculator"
    assert out.result == 4               # deterministic, no real LLM

def test_parse_rejects_bad_json():
    with pytest.raises(ToolArgError):
        parse_tool_args('{"expr": ')      # malformed → handled error
```

These run in milliseconds and never touch a provider, unlike a flow test.

## Pitfalls

- **Trying to unit-test the LLM's words.** Output text is nondeterministic — don't assert exact phrasings here; use [[deepeval|metric-based]] eval instead.
- **Real API calls in "unit" tests.** That makes them integration tests: slow, flaky, costly — mock the client.
- **Skipping error paths.** Tools fail (timeouts, bad input); test the failure branch, since that's what the agent must recover from.
- **Over-mocking.** Mocking so much that the test only verifies the mock proves nothing; test real logic, stub only the model and network.

## See also

- [[integration-testing-for-flows]]
- [[deepeval]]
