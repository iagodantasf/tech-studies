---
title: "Debuggers (gdb / lldb)"
track: cpp
group: Tooling & Build
tags: [cpp, debugging]
prerequisites: [how-c-works-compilation-model, pointers]
see-also: [sanitizers-asan-ubsan-tsan, profilers-perf-valgrind, dangling-pointers-memory-leaks]
---

# Debuggers (gdb / lldb)

gdb (GNU) and lldb (LLVM) are interactive symbolic debuggers that stop a running program at chosen points so you can inspect state, step through code, and trace how a bug arose.

## Why it matters

When a crash, hang, or wrong result resists reasoning, a debugger lets you observe ground truth: actual variable values, the call stack, and the exact faulting instruction. They are essential for post-mortem analysis of core dumps from production and for understanding [[dangling-pointers-memory-leaks|memory corruption]] and stack overflows. gdb dominates Linux; lldb is native on macOS and ships with Clang, sharing nearly identical concepts.

## How it works

You must compile with debug info (`-g`) and ideally `-O0` so symbols and line numbers map cleanly. The debugger then controls execution via ptrace and reads DWARF symbols.

| Intent | gdb | lldb |
|---|---|---|
| Run | `run` | `run` |
| Breakpoint at line | `break file.cpp:42` | `b file.cpp:42` |
| Step over / into | `next` / `step` | `next` / `step` |
| Continue | `continue` | `continue` |
| Backtrace | `bt` | `bt` |
| Print expr | `print x` / `p *p` | `p x` / `p *p` |
| Watch a variable | `watch x` | `watch set var x` |

- **Breakpoints** can be conditional (`break foo if i==500`) and can run commands automatically; **watchpoints** stop the instant a memory location changes — invaluable for "who corrupted this?".
- On a crash, load the **core dump** (`gdb ./app core`) and `bt` to see the stack at the moment of `SIGSEGV` — post-mortem debugging without rerunning.
- `frame N` / `up` / `down` move through the call stack; `info locals`, `info args`, and pretty-printers display STL containers readably.
- Reverse debugging (`record` then `reverse-step` in gdb) and **TUI** (`Ctrl-X A`) help, though optimized (`-O2`) builds inline and reorder code, so values may show `<optimized out>`.

## Example

```bash
g++ -g -O0 app.cpp -o app
gdb ./app
(gdb) break compute.cpp:88
(gdb) run
(gdb) p vec.size()        # inspect an STL container
(gdb) watch total         # stop when `total` changes
(gdb) bt                  # call stack at the stop
```

Debugging a `SIGSEGV` from a null deref: `run` stops at the fault, `bt` names the function, `p ptr` shows `0x0`, and `frame` reveals where the bad pointer came from.

## Pitfalls

- **No `-g` (or stripped binary)** leaves you stepping through bare addresses with no source — always build debug symbols for the binary under test.
- **Optimized builds lie**: `-O2` inlines functions and elides locals (`<optimized out>`), and line stepping jumps around; debug at `-O0`/`-Og` when possible.
- **Heisenbugs**: data races and uninitialized reads often vanish under the debugger's altered timing — reach for [[sanitizers-asan-ubsan-tsan|sanitizers]] for those instead.
- **Core dumps disabled**: `ulimit -c 0` (common default) means no core file is written; set `ulimit -c unlimited` first or you lose the post-mortem.

## See also

- [[sanitizers-asan-ubsan-tsan]]
- [[profilers-perf-valgrind]]
- [[dangling-pointers-memory-leaks]]
