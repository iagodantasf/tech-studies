---
title: Copy vs Move
track: cpp
group: Memory Management
tags: [cpp, copy-move]
prerequisites: [constructors-destructors, copy-move-constructors]
see-also: [move-semantics-rvalue-references, the-rule-of-0-3-5, object-lifetime]
---

# Copy vs Move

Copying duplicates an object's resources (the source stays intact); moving transfers them (the source is left empty) — same syntax, very different cost and post-conditions.

## Why it matters

Whether a given `T x = y;` or function return *copies* or *moves* is the difference between O(n) and O(1) for resource-owning types, and it silently changes the state of the source. Knowing which special member the compiler picks — and when it picks neither because of copy elision — is essential for both performance and correctness around [[object-lifetime]].

## How it works

The compiler selects copy vs move by the **value category** of the initializer: an lvalue binds the copy overload, an rvalue prefers the move overload. After the operation, a copied-from object is unchanged; a moved-from object is valid but unspecified — see [[move-semantics-rvalue-references]].

| | Copy | Move |
|---|---|---|
| Triggered by | lvalue source | rvalue source (temp / `std::move`) |
| Source after | unchanged | valid, unspecified (often empty) |
| Cost for `vector<T>` | O(n), allocates | O(1), steals buffer |
| Member called | `T(const T&)` | `T(T&&)` |

- If no move members exist, an rvalue **falls back to copy** — moving is an optimization, never a guarantee.
- **Copy elision** (mandatory for prvalues since C++17) can construct directly in place, doing *neither* copy nor move — e.g. returning a local.

## Example

```cpp
std::vector<int> big = make();       // prvalue → elided: constructed in place, 0 copies/moves
std::vector<int> a = big;            // lvalue  → COPY: new heap buffer, big intact
std::vector<int> b = std::move(big); // rvalue  → MOVE: steals buffer, big now empty
```

`a` doubles memory and walks every element; `b` swaps a few pointers and leaves `big` valid but emptied.

## Pitfalls

- **Assuming a move happened**: a move-disabled or `const` type copies silently — profile/inspect for hot paths.
- **`= default`-ing one of the five** can suppress the implicit move (Rule of 5); declaring a destructor stops move generation — see [[the-rule-of-0-3-5]].
- **Self-assignment** in a hand-written copy assignment can free-then-read; guard `if (this != &o)` or copy-and-swap.
- **Throwing move ctor**: containers fall back to copying on resize unless your move is [[noexcept]], silently losing the win.

## See also

- [[move-semantics-rvalue-references]]
- [[the-rule-of-0-3-5]]
- [[object-lifetime]]
