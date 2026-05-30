---
title: Computer Science
roadmap: computer-science
status: learning        # not-started | learning | done
started: 2026-05-30
updated: 2026-05-30
tags: [roadmap, cs]
---

# Computer Science

> roadmap.sh: https://roadmap.sh/computer-science

Track for the **Computer Science** roadmap. Tick nodes as you cover them — `build-dashboard.mjs`
counts these checkboxes for the progress %. (This track is the worked example — copy its shape for new roadmaps.)

## Nodes

### Foundations
- [ ] Pseudo code
- [ ] Programming paradigms (procedural, OOP, functional)

### Data structures
- [ ] Arrays & dynamic arrays
- [ ] Linked lists
- [ ] Stacks & queues
- [x] Hash tables → [[hash-tables]]
- [ ] Trees (BST, AVL, B-tree)
- [ ] Heaps & priority queues
- [ ] Graphs
- [ ] Tries

### Algorithms
- [x] Searching (linear, binary) → [[binary-search]]
- [ ] Sorting (merge, quick, heap)
- [ ] Recursion
- [ ] Divide & conquer
- [ ] Greedy algorithms
- [ ] Dynamic programming
- [ ] Backtracking
- [ ] Graph algorithms (BFS, DFS, Dijkstra)

### Complexity
- [x] Asymptotic notation (Big-O, Θ, Ω)
- [ ] Time & space complexity
- [ ] Complexity classes (P, NP)

### Math & bits
- [ ] Bit manipulation
- [ ] Number theory basics
- [ ] Floating-point representation
- [ ] Character encodings (ASCII, Unicode)

### Systems
- [ ] Computer architecture (CPU, memory hierarchy, cache)
- [ ] Operating systems (processes, threads, scheduling, memory mgmt)
- [ ] Concurrency & deadlocks
- [ ] Networking (OSI, TCP/IP, HTTP, DNS)
- [ ] Databases (indexing, transactions)

### Theory
- [ ] Automata & formal languages
- [ ] Compilers & interpreters
- [ ] Cryptography basics

## Notes
<!-- Index your notes/ files here, newest first. -->
- [[hash-tables]] — collision strategies, load factor, amortized O(1)
- [[binary-search]] — invariant, off-by-one traps; impl in `playgrounds/rust/binary-search`

## Resources
See [resources.md](./resources.md).

## Project ideas
- Build a hash map from scratch (open addressing vs chaining) and benchmark
- Implement a tiny interpreter (see *Crafting Interpreters*)
