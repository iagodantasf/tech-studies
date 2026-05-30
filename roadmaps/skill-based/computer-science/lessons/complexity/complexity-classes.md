---
title: Complexity classes (P, NP)
track: computer-science
group: Complexity
tags: [cs, complexity, p-vs-np]
prerequisites: [time-and-space-complexity]
see-also: [asymptotic-notation, graph-algorithms, dynamic-programming]
---

# Complexity classes (P, NP)

Complexity classes group **decision problems** by the resources needed to solve them, drawing the
line between "tractable" (polynomial time) and "we only know how to brute-force it".

## Why it matters

Recognizing that a problem is **NP-hard** changes your strategy: stop hunting for a fast exact
algorithm and reach for approximations, heuristics, or [[dynamic-programming]] on small inputs
instead. The famous **P vs NP** question — are these classes equal? — is the deepest open problem in
computer science and underpins modern cryptography.

## How it works

Built on [[time-and-space-complexity|time complexity]], the core classes for yes/no problems:

- **P** — solvable in **polynomial time** (`O(n^k)`). The practical "efficient" tier: shortest path,
  sorting, [[graph-algorithms|reachability]].
- **NP** — a *proposed* yes-answer can be **verified** in polynomial time, even if finding it seems
  hard. Sudoku, SAT, subset-sum.
- **NP-complete** — the hardest problems *in* NP; every NP problem reduces to them. Solve one in
  polynomial time and you solve all of them. SAT, 3-coloring, Hamiltonian cycle.
- **NP-hard** — at least as hard as NP-complete, but **not necessarily in NP** (may not even be a
  decision problem), e.g. the optimization form of the travelling salesman.

`P ⊆ NP` (solving implies verifying). Whether `P = NP` is **unknown**; almost everyone believes
`P ≠ NP`. A **reduction** transforms problem A into problem B in polynomial time, proving B is "at
least as hard as" A — the main tool for showing NP-hardness.

```
        ┌─────────── NP ───────────┐
        │   ┌───────┐              │
        │   │   P   │  NP-complete │      NP-hard extends
        │   └───────┘      ●───────┼──────► beyond NP
        └──────────────────────────┘
```

## Example

**Boolean satisfiability (SAT)** — given a formula like `(x_1 ∨ ¬x_2) ∧ (x_2 ∨ x_3)`, is there an
assignment making it true? Checking a *given* assignment is `O(n)` (so SAT is in NP), but no known
algorithm *finds* one in polynomial time. Cook–Levin proved SAT is **NP-complete** — the original
anchor every other NP-completeness proof reduces from.

## Pitfalls

- **"NP" means "non-polynomial".** It does not — it means *nondeterministic polynomial* /
  polynomial-time *verifiable*. P problems are in NP.
- **Assuming NP-hard means unsolvable.** You can still solve small instances exactly, or large ones
  approximately; intractable is not impossible.
- **Confusing verify with solve.** Easy-to-check is not easy-to-find — that gap *is* the P vs NP
  question.

## See also

- [[time-and-space-complexity]]
- [[asymptotic-notation]]
- [[graph-algorithms]]
- [[dynamic-programming]]
