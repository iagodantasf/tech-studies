---
title: Recursion
track: cpp
group: Functions
tags: [cpp, recursion]
prerequisites: [declaring-defining-functions]
see-also: [stack-vs-heap, divide-and-conquer]
---

# Recursion

Recursion is a function calling itself to solve a problem by reducing it to smaller instances — in C++ it runs on the call stack, so depth and tail-call behavior have concrete machine consequences.

## Why it matters

The algorithm-level idea is covered in [[recursion]]; what's C++-specific is *cost*. Each call pushes a stack frame, and the default stack is small — typically **1 MB on Windows, 8 MB on Linux** — so deep or unbounded recursion overflows and crashes (often with no clean exception). Unlike some functional languages, C++ does **not guarantee tail-call optimization**, so you cannot rely on recursion-as-iteration. This shapes whether recursion is safe or must be rewritten as a loop.

## How it works

- Every call allocates a frame on the [[stack-vs-heap|stack]]: return address, saved registers, locals, parameters.
- **Base case** halts recursion; missing or unreachable base case → infinite recursion → stack overflow.
- **Tail call**: the recursive call is the last action. Compilers *may* turn it into a jump (reusing the frame) at `-O2`, but the standard doesn't require it — GCC/Clang often do, MSVC less reliably.
- Default thread stack sizes give a depth budget roughly:

| Frame size | 1 MB stack | 8 MB stack |
|---|---|---|
| 64 B | ~16k calls | ~131k calls |
| 256 B | ~4k calls | ~32k calls |

- Convert to iteration with an explicit `std::stack` when depth is data-driven and unbounded.

## Example

```cpp
// O(n) stack depth — fine for small n, overflows for n in the millions
long sum_to(long n) { return n == 0 ? 0 : n + sum_to(n - 1); }

// Tail-recursive form; -O2 may compile this to a loop (no growth)
long sum_acc(long n, long acc = 0) {
  return n == 0 ? acc : sum_acc(n - 1, acc + n);
}
```

`sum_to(1'000'000)` may crash; the iterative `for` loop equivalent never does.

## Pitfalls

- **Stack overflow is undefined behavior**, not a catchable exception — usually an immediate `SIGSEGV` with no stack unwinding (no destructors run).
- **Never assume TCO**: a "tail-recursive" function can still blow the stack in debug builds or under MSVC. Profile or rewrite for unbounded depth.
- **Accidental infinite recursion** from a base case that's never hit (e.g. recursing on `n-2` with odd `n`) overflows fast.
- Deep recursion **defeats `constexpr`**: compilers cap constant-evaluation depth (e.g. Clang's `-fconstexpr-depth`, default 512).

## See also

- [[recursion]]
- [[stack-vs-heap]]
