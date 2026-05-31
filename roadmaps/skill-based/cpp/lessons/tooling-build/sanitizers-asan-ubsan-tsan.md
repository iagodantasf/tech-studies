---
title: "Sanitizers (ASan, UBSan, TSan)"
track: cpp
group: Tooling & Build
tags: [cpp, sanitizers]
prerequisites: [pointers, memory-model-data-races]
see-also: [debuggers-gdb-lldb, profilers-perf-valgrind, dangling-pointers-memory-leaks]
---

# Sanitizers (ASan, UBSan, TSan)

Sanitizers are compiler-inserted runtime checks (in GCC and Clang) that detect memory errors, undefined behavior, and data races by instrumenting the program at build time.

## Why it matters

C++'s undefined behavior — buffer overflows, use-after-free, [[memory-model-data-races|data races]], signed overflow — often produces no crash, just silent corruption or sporadic failures. Sanitizers turn that latent UB into an immediate, well-located error report with a stack trace, catching bugs that pass code review and tests. They are now standard in CI for any serious C++ project and complement [[debuggers-gdb-lldb|debuggers]] (which see only the symptom) by pinpointing the cause.

## How it works

You rebuild with `-fsanitize=<kind> -g` and run normally; the instrumentation maintains shadow memory or a happens-before graph and aborts with a diagnostic on the first violation.

| Sanitizer | Flag | Catches | Slowdown |
|---|---|---|---|
| Address (ASan) | `-fsanitize=address` | heap/stack overflow, use-after-free | ~2x |
| Undefined (UBSan) | `-fsanitize=undefined` | signed overflow, bad shifts, null deref | ~1.2x |
| Thread (TSan) | `-fsanitize=thread` | data races, lock-order issues | ~5-15x |
| Leak (LSan) | `-fsanitize=leak` | leaked allocations at exit | small |
| Memory (MSan) | `-fsanitize=memory` | reads of uninitialized memory | ~3x |

- **ASan** redzones every allocation and quarantines freed memory, so an off-by-one write or a read after `delete` hits a poisoned byte and reports the alloc/free/access stacks.
- **TSan** records a happens-before relation across threads; it flags a race even if it didn't manifest this run, but multiplies memory ~5-10x and time ~5-15x.
- **UBSan** is cheap enough to leave on in many test builds; combine `address,undefined` (ASan+UBSan are compatible). **TSan and ASan/MSan are mutually exclusive** — separate builds.
- Tune via env vars: `ASAN_OPTIONS=detect_leaks=1:halt_on_error=0`, and set `ASAN_SYMBOLIZER_PATH`/build with `-g` for readable traces.

## Example

```bash
clang++ -fsanitize=address -fno-omit-frame-pointer -g app.cpp -o app
./app
# ==1234==ERROR: AddressSanitizer: heap-use-after-free on 0x...
#   READ of size 4 ... #0 main app.cpp:12   <- the bad access
#   freed by thread T0 here: ... app.cpp:10 <- where it was deleted
#   previously allocated here: ... app.cpp:8
```

The report names the access site, the `free`, and the original `new` — three stacks that usually localize the bug instantly.

## Pitfalls

- **Sanitizers aren't free and aren't a release config**: ASan roughly doubles time and memory; never ship sanitized binaries — they expand layout and are not a security boundary.
- **You can't combine TSan with ASan/MSan** in one build; run separate CI jobs.
- **Third-party / system libs without instrumentation** can hide errors or cause false negatives; for uninitialized-read checks (MSan) *all* code including libc++ must be instrumented.
- **`detect_leaks` defaults vary** by platform (off on macOS); a "no leaks" run may simply mean LSan wasn't enabled.

## See also

- [[debuggers-gdb-lldb]]
- [[profilers-perf-valgrind]]
- [[dangling-pointers-memory-leaks]]
