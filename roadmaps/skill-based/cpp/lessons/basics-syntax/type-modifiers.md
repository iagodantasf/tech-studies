---
title: Type Modifiers
track: cpp
group: Basics / Syntax
tags: [cpp, types]
prerequisites: [data-types]
see-also: [const-pointers-pointer-to-const, variables-and-constants]
---

# Type Modifiers

Keywords like `signed`, `unsigned`, `short`, `long`, `const`, and `volatile` adjust an existing type's range, width, or mutability rather than introducing a new fundamental type.

## Why it matters

The signed/unsigned choice is a frequent bug source: mixing them in one expression triggers the **usual arithmetic conversions**, which can flip a comparison's result and produce silent wrap-around. `const` is the backbone of const-correctness, letting APIs promise they won't mutate a borrowed object — which the compiler enforces and optimizes around. `volatile` is narrow but critical in memory-mapped I/O and signal handlers.

## How it works

Modifiers stack: `unsigned long long`, `const volatile char`. They split into two axes — *value* modifiers (width/sign) and *cv-qualifiers* (mutability/visibility).

- **`signed` / `unsigned`** — sign of integers. Unsigned arithmetic is modular (wraps at `2^N`); signed overflow is UB.
- **`short` / `long`** — shrink or widen integer width (`short int`, `long double`).
- **`const`** — object cannot be modified through this name; enables read-only optimizations and `.rodata` placement.
- **`volatile`** — every access must hit memory; the compiler may not cache or elide it. *Not* a threading primitive — use [[atomics]] for that.

| Expression | Type | Result | Why |
|---|---|---|---|
| `-1 < 0u` | mixed | `false` | `-1` → `4294967295u` |
| `5u - 10u` | unsigned | huge | modular wrap |
| `1L << 40` | `long` | `2^40` | wide enough |

See [[const-pointers-pointer-to-const]] for where `const` binds on pointer types.

## Example

```cpp
unsigned a = 1, b = 2;
std::cout << a - b;        // 4294967295, not -1 (modular)
for (unsigned i = n; i >= 0; --i) { /* ... */ }   // INFINITE: i>=0 always true
volatile uint32_t* reg = mmio_addr();
*reg = 1;                  // never optimized away
```

## Pitfalls

- **Signed/unsigned comparison** silently converts the signed operand; enable `-Wsign-compare`.
- **Counting down with an unsigned loop var** to `>= 0` never terminates — it wraps to a large value.
- **`volatile` does not make code thread-safe** and gives no atomicity or ordering — a common, dangerous myth.
- **`const` can be cast away** with `const_cast`, but mutating a truly-const object afterward is UB.

## See also

- [[data-types]]
- [[const-pointers-pointer-to-const]]
