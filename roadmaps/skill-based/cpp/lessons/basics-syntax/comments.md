---
title: Comments
track: cpp
group: Basics / Syntax
tags: [cpp, syntax]
prerequisites: []
see-also: [preprocessor-macros, static-analysis-clang-tidy-cppcheck]
---

# Comments

C++ has two comment forms — line `//` and block `/* */` — stripped by the preprocessor before compilation; by convention they also drive Doxygen API docs and tooling directives.

## Why it matters

Comments are the only place to record *why*, not *what* — the rationale, the invariant, the link to the bug — which the code itself can't express. They also double as machine-readable contracts: Doxygen turns `///` blocks into API reference, and pragmas like `// NOLINT` or `// clang-format off` steer [[static-analysis-clang-tidy-cppcheck|linters]] and formatters. Bad comments (restating code, going stale) are worse than none.

## How it works

- **`//`** runs to end of line. **`/* */`** spans lines but **does not nest** — the first `*/` closes it.
- The preprocessor replaces each comment with a single space *before* tokenization, so `a/**/b` is two tokens.
- **Doxygen** recognizes `///`, `/** */`, and `@`/`\` tags (`@param`, `@return`, `@brief`) to generate docs.
- **Tool directives** are ordinary comments parsed by external tools, not the compiler: `// NOLINT(rule)`, `// clang-format off`, `// TODO(user):`.

| Form | Nests | Spans lines | Common use |
|---|---|---|---|
| `//` | n/a | no | inline notes, most code |
| `/* */` | no | yes | license headers, doc blocks |
| `///` `/** */` | no | yes | Doxygen API docs |

To disable code, prefer `#if 0 ... #endif` over block comments — see [[preprocessor-macros]].

## Example

```cpp
/// Computes a 32-bit FNV-1a hash.
/// @param data bytes to hash  @return non-cryptographic digest
std::uint32_t fnv1a(std::span<const std::byte> data);

int x = compute();  // NOLINT(cppcoreguidelines-init): set below
/* legacy path
   if (old) { ... }   // a /* here would NOT open a nested comment */
```

## Pitfalls

- **No nesting**: wrapping a block that already contains `*/` ends the comment early and leaves dangling code — use `#if 0` to "comment out" code spans.
- **Line-continuation trap**: a `//` comment ending in a backslash splices the next line into the comment (phase-2 line splicing).
- **Stale comments lie**: a comment contradicting the code is a defect; delete rather than mislead.
- **Commented-out code rots**; version control already remembers it — prefer deletion.

## See also

- [[preprocessor-macros]]
- [[static-analysis-clang-tidy-cppcheck]]
