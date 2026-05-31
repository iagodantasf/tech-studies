---
title: Tree of Thought (ToT)
track: ai-agents
group: Agent Architectures
tags: [ai-agents, reasoning]
prerequisites: [chain-of-thought-cot]
see-also: [react-reason-act, backtracking]
---

# Tree of Thought (ToT)

A reasoning architecture that explores **multiple** candidate reasoning paths as a search tree — generating several next thoughts at each step, scoring them, and backtracking from dead ends.

## Why it matters

[[chain-of-thought-cot|CoT]] commits to one linear chain; if an early step is wrong, the whole answer is wrong with no recovery. ToT treats reasoning as [[searching|search]] over a tree of partial solutions, so the model can branch, evaluate, prune bad branches, and [[backtracking]] — turning a one-shot guess into a deliberate look-ahead. On tasks needing exploration (Game of 24, puzzles, planning), the original paper reports ToT solving 74% of Game-of-24 cases versus ~4% for CoT. The cost is many more LLM calls, so it's reserved for hard problems where a single chain reliably fails.

## How it works

Four pluggable components, run as a [[trees|tree]] search:

| Component | Job |
|---|---|
| Thought generator | propose k next steps from a node |
| State evaluator | score each node (LLM rates "sure/maybe/no" or a value) |
| Search strategy | BFS or DFS over the frontier |
| Pruning | drop low-scored branches; keep top-b (beam) |

The loop, in prose: from the current partial solution, **generate** k candidate next thoughts; **evaluate** each (have the model judge how promising it is); **keep** the best b (the beam width); expand those next. DFS dives deep and [[backtracking]] on a dead end; BFS keeps a frontier of the b best states per depth. Search ends at a complete solution or a depth limit. Total cost scales with branching: roughly `b × depth × (generate + evaluate)` calls — easily 50–100× a single CoT pass.

## Example

Game of 24 with inputs `4, 9, 10, 13` (combine to make 24):

```
root: {4,9,10,13}
 ├─ 13-9=4  -> {4,4,10}   eval: maybe
 │   └─ 10-4=6 -> {4,6}   -> 4*6=24  ✓ SOLVED
 ├─ 10-4=6  -> {6,9,13}   eval: no   (pruned)
 └─ 4+9=13  -> {10,13,13} eval: no   (pruned)
```

The evaluator kills the two weak branches early; the search spends its budget on the promising `{4,4,10}` line and finds `(13-9)` then `(10-4)·4 = 24`.

## Pitfalls

- **Cost explosion.** Branching factor × depth multiplies calls fast; cap beam width and depth or a single question costs dollars and minutes.
- **Weak evaluator = blind search.** If the LLM can't reliably score partial states, pruning is random and ToT degrades to expensive guessing — validate the evaluator first.
- **Wrong tool for the job.** ToT shines only when problems decompose into checkable intermediate states; for retrieval-style tasks, [[react-reason-act|ReAct]] grounding beats deeper internal search.
- **Confusing ToT with multi-sample.** Self-consistency (sample N chains, majority-vote) is *not* ToT — it has no per-state evaluation or backtracking.

## See also

- [[react-reason-act]]
- [[backtracking]]
