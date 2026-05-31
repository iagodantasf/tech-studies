---
title: Input / Output (iostream)
track: cpp
group: Basics / Syntax
tags: [cpp, io]
prerequisites: [operators]
see-also: [std-string-std-string-view, error-codes-std-expected]
---

# Input / Output (iostream)

`<iostream>` provides type-safe, extensible stream I/O via overloaded `<<` and `>>` on `std::cin`, `std::cout`, `std::cerr`, replacing C's format-string `printf`/`scanf`.

## Why it matters

Streams are type-safe — the compiler picks the right insertion overload, so there's no `printf("%d", a_string)` mismatch crashing at runtime. They're extensible: overload `operator<<` for your type and it composes with the whole library (see [[operator-overloading]]). The trade-off is speed and verbosity, which is why C++20 added `std::format` for `printf`-style ergonomics with type safety, and why `std::sync_with_stdio(false)` is a known throughput win.

## How it works

`std::cout << x` returns the stream, so calls chain left-to-right ([[operators]] associativity). Streams carry **state flags** checked after each op.

- **`<<` / `>>`** insert/extract; `>>` skips leading whitespace and stops at the next, so it reads tokens, not lines.
- **`std::getline(std::cin, s)`** reads a whole line including spaces.
- **State**: `good()`, `eof()`, `fail()`, `bad()`; the stream is truthy while not failed — `while (cin >> x)` loops until extraction fails.
- **Manipulators**: `std::endl` (newline **+ flush**), `'\n'` (newline only), `std::setw`, `std::hex`, `std::boolalpha`.

| Stream | Target | Buffered | Notes |
|---|---|---|---|
| `cin` | stdin | yes | tied to `cout` |
| `cout` | stdout | yes | flush on `endl`/exit |
| `cerr` | stderr | no | unbuffered, immediate |
| `clog` | stderr | yes | for logging |

## Example

```cpp
int n;
if (!(std::cin >> n)) { std::cerr << "bad input\n"; return 1; }
std::cout << std::hex << 255 << '\n';        // ff
std::cout << std::format("{:>6}\n", 42);     // C++20: "    42"

std::string line;
while (std::getline(std::cin, line)) process(line);
```

## Pitfalls

- **`std::endl` flushes every call** — in a hot loop that's a syscall per line; use `'\n'` and let the buffer flush.
- **Mixing `>>` then `getline`** leaves the trailing newline in the buffer, so `getline` returns empty; consume it with `std::ws`.
- **Failed extraction is sticky**: once `failbit` is set, later reads are no-ops until you `cin.clear()` and discard bad input.
- **`std::cout` isn't flushed on crash**; for last-gasp diagnostics use unbuffered `std::cerr`.

## See also

- [[std-string-std-string-view]]
- [[operator-overloading]]
