---
title: Object Lifetime
track: cpp
group: Memory Management
tags: [cpp, lifetime]
prerequisites: [constructors-destructors, stack-vs-heap]
see-also: [raii, dangling-pointers-memory-leaks, move-semantics-rvalue-references]
---

# Object Lifetime

An object's lifetime is the span between the completion of its constructor and the start of its destructor; using its storage outside that window is undefined behavior.

## Why it matters

Lifetime is the rule that makes [[raii]] work and the rule that, when broken, produces dangling references, use-after-free, and use-before-init — the most common UB in C++. The language defines *storage duration* (how long the memory exists) separately from lifetime (when the object is valid), and confusing the two is exactly how a reference can point to live memory holding a dead object.

## How it works

Storage duration determines *when* memory is allocated; lifetime begins when construction finishes. The four storage durations:

| Duration | Allocated | Lifetime ends | Example |
|---|---|---|---|
| automatic | on entry to scope | scope exit | local variable |
| static | program start | program end | `static`, globals |
| dynamic | on `new` | on `delete` | heap object |
| thread | thread start | thread end | `thread_local` |

- Automatic objects are destroyed in **reverse order of construction** at the end of their block.
- A `const&` or `T&&` bound to a temporary **extends** that temporary's lifetime to the reference's scope — but only the immediate temporary, not subobjects reached through it.
- Ending a lifetime early via explicit `p->~T()` leaves valid storage but a dead object; touching it before re-construction is UB.

## Example

```cpp
const std::string& good = std::string("hi");      // temporary lifetime EXTENDED to 'good'
const char*        bad  = std::string("hi").c_str(); // temporary dies at ';' → dangling

std::string_view sv = std::string("tmp");         // sv now views freed memory — UB
```

`good` is safe; `bad` and `sv` point into a string that was destroyed at the end of the full-expression. See [[dangling-pointers-memory-leaks]].

## Pitfalls

- **Returning a reference/pointer to a local** dangles — the automatic object dies at return.
- **Lifetime extension does not chain** through function returns or member accessors; only a directly-bound temporary is extended.
- **Static init order fiasco**: cross-TU `static` objects have unspecified relative init order; use a function-local static (Meyers singleton) instead.
- **`string_view`/`span` over a temporary** is a classic dangle — the view outlives the buffer.

## See also

- [[raii]]
- [[dangling-pointers-memory-leaks]]
- [[move-semantics-rvalue-references]]
