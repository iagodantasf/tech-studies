---
title: Friend Functions / Classes
track: cpp
group: Structures & OOP
tags: [cpp, friend]
prerequisites: [access-specifiers, classes-objects]
see-also: [operator-overloading, encapsulation, static-members]
---

# Friend Functions / Classes

A `friend` declaration grants a specific external function or class access to a type's `private` and `protected` members, a deliberate, named hole in [[encapsulation]].

## Why it matters

Friendship is the standard solution when an operation logically belongs to a class but cannot be a member — most often `operator<<` for streaming, where the left operand is an `ostream`, not your type. It also enables tightly coupled pairs (a container and its iterator, a class and its test fixture) to share internals without exposing them to the world via public getters.

## How it works

`friend` appears *inside* the granting class and confers access; it is not affected by `public`/`private` placement and is not inherited or transitive.

- **Not symmetric**: `A` befriending `B` lets `B` see `A`'s internals, not vice-versa.
- **Not inherited**: a friend of a base is not a friend of derived classes, nor are a friend's members friends.
- **Not transitive**: a friend of a friend gets nothing.
- A **hidden friend** — a `friend` function *defined* inside the class body — is found only by argument-dependent lookup (ADL), which keeps overload sets small and speeds compilation.
- Friendship is granted by the class, so it cannot be added from outside — it does not break the owner's control over its invariants.

## Example

Streaming needs a free function whose left operand is `ostream`; `friend` lets it reach private state:

```cpp
class Vec3 {
  double x_, y_, z_;
public:
  friend std::ostream& operator<<(std::ostream& os, const Vec3& v) {
    return os << v.x_ << ',' << v.y_ << ',' << v.z_;  // sees privates
  }
};
std::cout << Vec3{1, 2, 3};   // found via ADL (hidden friend)
```

Defining `operator<<` as a member is impossible — you cannot add a member to `std::ostream`.

## Pitfalls

- **Overuse couples classes**: every friend is code that breaks when you change the representation; reach for it only when a member or public API genuinely cannot serve.
- Beginners expect friendship to be **mutual or inherited** — it is neither; each grant is one-directional and explicit.
- A non-hidden friend `operator` defined out-of-line still needs a separate declaration; the hidden-friend idiom avoids that.
- Granting `friend class Test;` for unit tests bakes test scaffolding into production headers — prefer testing through the public API.

## See also

- [[operator-overloading]]
- [[encapsulation]]
- [[static-members]]
