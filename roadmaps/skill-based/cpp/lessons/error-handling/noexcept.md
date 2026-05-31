---
title: "`noexcept`"
track: cpp
group: Error Handling
tags: [cpp, noexcept]
prerequisites: [exceptions-try-catch-throw, move-semantics-rvalue-references]
see-also: [exceptions-try-catch-throw, exception-safety-guarantees, move-semantics-rvalue-references]
---

# `noexcept`

`noexcept` is both a **specifier** that promises a function throws nothing, and an **operator** that asks at compile time whether an expression can throw.

## Why it matters

It is not just documentation: the standard library *queries* `noexcept` to pick faster code paths. `vector` only **moves** elements during reallocation if the move constructor is `noexcept` — otherwise it copies, to preserve the strong guarantee ([[exception-safety-guarantees]]). Marking move operations and `swap` `noexcept` is therefore a concrete performance lever, not a stylistic choice. It also lets the compiler omit exception-unwinding tables for that function.

## How it works

| Form | Meaning |
|---|---|
| `void f() noexcept;` | f promises not to throw |
| `void f() noexcept(B);` | conditional: no-throw iff `B` is true |
| `noexcept(expr)` | operator -> `true`/`false`, does **not** evaluate `expr` |

- If a `noexcept` function *does* throw, the runtime calls `std::terminate` immediately — there is **no** way to catch it outside. It is a hard promise.
- Destructors and deallocation functions are **implicitly `noexcept`** since C++11; so are compiler-generated move/copy ops when their members don't throw.
- The conditional form propagates: `swap(a,b) noexcept(noexcept(a.swap(b)))` is no-throw exactly when the member swap is.
- `noexcept` is part of the type since C++17 — a `void()noexcept` pointer is distinct from `void()`, and you cannot assign a throwing function to a `noexcept` pointer.

## Example

Conditional `noexcept` makes a wrapper's move "transparent" — no-throw only when the underlying member is:

```cpp
template <class T>
struct Box {
  T value;
  Box(Box&& o) noexcept(std::is_nothrow_move_constructible_v<T>)
    : value(std::move(o.value)) {}
};

static_assert(noexcept(Box<int>{Box<int>{}}));      // int move can't throw
// Box<std::list<int>> move is also noexcept; a throwing-move T would be false
```

Because the spec is conditional, `std::vector<Box<int>>` reallocation uses moves, not copies.

## Pitfalls

- **A lie is fatal, not a bug report.** Declaring `noexcept` then throwing skips all handlers and calls `terminate` — you cannot recover. Only promise it when truly true.
- **Operator vs specifier confusion:** `noexcept(f())` is the *query* operator (yields a bool); `void g() noexcept(f())` uses that bool as the *condition*. Easy to misread.
- **Unconditionally marking move ops `noexcept` on a type with a throwing member** is the lie above; use the `is_nothrow_*` traits to stay honest.
- **Forgetting `noexcept` on a cheap move** quietly forces `vector` to copy — invisible until you profile reallocation-heavy code.

## See also

- [[exceptions-try-catch-throw]]
- [[exception-safety-guarantees]]
- [[move-semantics-rvalue-references]]
