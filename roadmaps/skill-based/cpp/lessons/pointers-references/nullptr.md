---
title: "`nullptr`"
track: cpp
group: Pointers & References
tags: [cpp, pointers]
prerequisites: [pointers]
see-also: [pointers, const-pointers-pointer-to-const, smart-pointers-unique-ptr-shared-ptr-weak-ptr, utility-types-pair-tuple-optional-variant-any]
---

# `nullptr`

`nullptr` is the typed null-pointer literal (C++11), a `std::nullptr_t` value that converts to any pointer type but never to an integer.

## Why it matters

It fixes a 30-year defect: the old `NULL`/`0` null constants were integers, which silently picked the wrong overload and broke generic code. `nullptr` makes "no object" unambiguous and type-safe, and is the canonical empty state for raw pointers and [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]].

## How it works

`NULL` is a macro that expands to `0` (or `0L`) — an integer constant that *happens* to convert to a pointer. `nullptr` has its own type `std::nullptr_t`, implicitly converts to *every* pointer type, but has **no** conversion to `int`.

| Literal | Type | `f(int)` vs `f(char*)` | In templates |
|---|---|---|---|
| `0` | `int` | calls `f(int)` | deduces `int` |
| `NULL` | `int`/`long` | calls `f(int)` (or ambiguous) | deduces integer |
| `nullptr` | `std::nullptr_t` | calls `f(char*)` | deduces `nullptr_t` |

A pointer is contextually convertible to `bool`, so `if (p)` means "non-null" and `if (!p)` means "null" — no need to write `p != nullptr`. The *value* of a null pointer need not be all-zero bits on exotic hardware, but `nullptr` always compares equal to a null pointer and zero-initialization yields null.

## Example

The overload-resolution trap that motivated the feature:

```cpp
void log(int code);
void log(const char* msg);

log(NULL);      // surprise: calls log(int) — NULL is 0
log(nullptr);   // calls log(const char*), as intended
```

In generic code, `nullptr_t` forwards cleanly while `0` would bind as `int` and fail to deduce a pointer:

```cpp
template <class T> void take(T*);
take(nullptr);  // T deduces from context / explicit T; 0 would not be a pointer
```

## Pitfalls

- **Don't reintroduce `NULL` or `0`** for pointers in new code — it defeats overload resolution and reads as an integer.
- **`nullptr` is not an address you may dereference.** `*static_cast<int*>(nullptr)` is undefined behavior; guard with `if (p)`.
- **Absent *value* ≠ null pointer.** For an optional non-pointer result use `std::optional`, not a sentinel pointer — see [[utility-types-pair-tuple-optional-variant-any]].
- **`nullptr_t` has exactly one value;** you can pass it but cannot do arithmetic or comparison-ordering on it.

## See also

- [[pointers]]
- [[smart-pointers-unique-ptr-shared-ptr-weak-ptr]]
- [[const-pointers-pointer-to-const]]
