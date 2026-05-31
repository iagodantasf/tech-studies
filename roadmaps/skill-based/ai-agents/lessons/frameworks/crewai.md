---
title: CrewAI
track: ai-agents
group: Frameworks
tags: [ai-agents, multi-agent]
prerequisites: [agent-loop, planner-executor]
see-also: [autogen, langgraph]
---

# CrewAI

A framework for **role-based multi-agent teams**: you define agents with a role, goal, and backstory, hand them tasks, and a Crew orchestrates them toward a shared objective.

## Why it matters

CrewAI's pitch is a high-level, opinionated model of a *team* rather than a low-level graph — you describe agents the way you'd staff a project ("Researcher", "Writer", "Editor") and it wires the collaboration. This makes role-decomposition workflows fast to express, where one über-prompt would be unreliable. It sits opposite [[langgraph]]: less control, much less boilerplate, with a sequential or hierarchical [[planner-executor|process]] handling task handoff for you.

## How it works

Three core objects plus a process that schedules them:

| Object | Defines |
|---|---|
| Agent | role, goal, backstory, LLM, tools |
| Task | description, expected output, owning agent |
| Crew | the agents + tasks + a process |
| Process | `sequential` or `hierarchical` execution |

- **`sequential`** runs tasks in order, piping each task's output into the next task's context — a clean pipeline.
- **`hierarchical`** adds a manager agent that decomposes work and delegates to workers, closer to [[planner-executor]].
- Each agent internally runs its own [[agent-loop]] over its assigned tools; the Crew only governs cross-agent flow.
- **Crews vs Flows**: a Crew is autonomous collaboration; CrewAI **Flows** add event-driven, deterministic orchestration for when you need explicit control.

## Example

A two-agent research-and-write crew:

```python
researcher = Agent(role="Analyst", goal="find facts on X", tools=[search])
writer     = Agent(role="Writer",  goal="draft a brief on X")

t1 = Task(description="Research X", agent=researcher,
          expected_output="5 bullet findings")
t2 = Task(description="Write 200-word brief", agent=writer, context=[t1])

Crew(agents=[researcher, writer], tasks=[t1, t2],
     process=Process.sequential).kickoff()
# t1 runs its own tool loop; its output auto-feeds t2 as context
```

`context=[t1]` threads the analyst's findings into the writer's prompt — the handoff you'd otherwise wire by hand.

## Pitfalls

- **Vague roles/goals.** The role and backstory *are* the system prompt; thin descriptions produce agents that wander off task.
- **Cost multiplies.** N agents each looping over tools means many LLM calls; a 3-agent crew can be 10x+ a single call — watch [[token-based-pricing|token spend]].
- **Hierarchical overhead.** The manager process adds delegation round-trips and can loop; prefer `sequential` unless you truly need dynamic delegation.
- **Hidden control flow.** When a crew misbehaves it's hard to trace which agent decided what; add tracing and keep task scopes narrow.

## See also

- [[autogen]]
- [[langgraph]]
