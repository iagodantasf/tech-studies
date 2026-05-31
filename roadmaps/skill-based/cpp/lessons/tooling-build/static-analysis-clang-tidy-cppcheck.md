---
title: "Static Analysis (clang-tidy, cppcheck)"
track: cpp
group: Tooling & Build
tags: [cpp, static-analysis]
prerequisites: [build-systems-cmake-make]
see-also: [sanitizers-asan-ubsan-tsan, unit-testing-googletest-catch2, the-rule-of-0-3-5]
---

# Static Analysis (clang-tidy, cppcheck)

Static analyzers inspect source code without running it, flagging bugs, undefined behavior, and style violations by reasoning about control and data flow at compile time.

## Why it matters

Unlike [[sanitizers-asan-ubsan-tsan|sanitizers]] (which need the buggy path to actually execute) and tests (which need you to think of the case), static analysis catches whole classes of defects on *every* line — null derefs, resource leaks, uninitialized members, integer overflow — before the code runs. clang-tidy additionally modernizes and enforces guidelines (C++ Core Guidelines, `readability-*`), making it a standard CI gate that scales review across large teams.

## How it works

clang-tidy reuses Clang's real parser (full type/AST knowledge) and runs *checks*; cppcheck is a standalone analyzer tuned for low false positives and needing no build setup.

| Tool | Needs compile flags? | Strength | Auto-fix |
|---|---|---|---|
| clang-tidy | yes (`compile_commands.json`) | deep AST, modernize, Core Guidelines | yes (`-fix`) |
| cppcheck | no (parses standalone) | leaks, bounds, few false positives | limited |

- clang-tidy needs a **compilation database** (`compile_commands.json`, emitted by `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`) so it sees the exact flags, includes, and standard each file uses.
- Checks are grouped by prefix: `bugprone-*`, `modernize-*` (e.g. raw loop → range-for, `NULL`→`nullptr`), `performance-*`, `cppcoreguidelines-*`, `readability-*`. Select with `-checks='bugprone-*,modernize-*'`.
- It can **rewrite code** with `-fix`/`-fix-errors` (e.g. apply `modernize-use-override` across a tree) and is configured per-repo via a `.clang-tidy` YAML file.
- **cppcheck** complements it: zero config, good at out-of-bounds and leak detection, and catches some flow bugs clang-tidy misses — many teams run both.

## Example

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
clang-tidy -p build --checks='bugprone-*,modernize-*' src/main.cpp
# warning: use range-based for [modernize-loop-convert]
# warning: prefer member initializer [cppcoreguidelines-prefer-member-initializer]

cppcheck --enable=warning,performance --std=c++20 src/
# error: Memory leak: buf [memleak]
```

A `.clang-tidy` with `WarningsAsErrors: 'bugprone-*'` turns selected checks into a hard CI failure.

## Pitfalls

- **No `compile_commands.json`** means clang-tidy guesses flags and floods you with bogus "file not found" / wrong-standard diagnostics — always generate the database.
- **False positives are real**: silence a justified case inline with `// NOLINT(check-name)` rather than disabling the whole check globally.
- **It can't see runtime values**: static analysis won't catch data races or input-dependent overflow that only sanitizers/tests find — they are complementary, not substitutes.
- **`-fix` on a dirty tree** can apply overlapping edits or touch generated files; run it on a clean checkout and review the diff.

## See also

- [[sanitizers-asan-ubsan-tsan]]
- [[unit-testing-googletest-catch2]]
- [[the-rule-of-0-3-5]]
