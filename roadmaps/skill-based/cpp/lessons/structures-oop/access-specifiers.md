---
title: Access Specifiers
track: cpp
group: Structures & OOP
tags: [cpp, access-control]
prerequisites: [classes-objects, structs]
see-also: [encapsulation, inheritance, friend-functions-classes]
---

# Access Specifiers

`public`, `protected`, and `private` control which code may name a member, enforcing the boundary between a class's interface and its implementation.

## How it works

Access is a **compile-time** check on *who is naming the member*, not a runtime guard — there is no memory protection, and a cast or offset can still reach the bytes.

| Specifier | Accessible from |
|---|---|
| `public` | anywhere |
| `protected` | the class and its derived classes |
| `private` | the class and its [[friend-functions-classes]] only |

- Access is **per-class, not per-object**: a member function of `Widget` can touch the `private` members of *any* `Widget`, including a different instance passed as an argument.
- Specifiers apply from their label until the next label; `struct` starts `public`, `class` starts `private` ([[structs]]).
- Inheritance has its own access mode (`class D : private B`) that caps how inherited members are exposed — see [[inheritance]].
- `protected` is the most misused: it breaks [[encapsulation]] toward subclasses, coupling them to your layout.

## Why it matters

Access control is the mechanism behind [[encapsulation]]: by hiding representation, you keep the freedom to change it without breaking callers. It is also what makes class invariants enforceable — if a field is `private`, the only way to change it is through methods you wrote to keep state valid.

## Example

```cpp
class Account {
  long cents_ = 0;                 // private: invariant-protected
protected:
  void audit();                    // visible to subclasses
public:
  void deposit(long c) { cents_ += c; }
  bool merge(const Account& o) {   // per-class access:
    cents_ += o.cents_;            // reaches o's PRIVATE field — OK
    return true;
  }
};
```

`merge` reading `o.cents_` compiles because access is keyed on the *class*, not the object.

## Pitfalls

- **Access is not security**: `reinterpret_cast` or a `#define private public` hack defeats it; never rely on it to hide secrets.
- `private` does not hide a member from **name lookup or overload resolution** — a private overload can still be *selected*, then rejected with an access error.
- Overusing `protected` data turns subclasses into a fragile API surface; prefer `private` data + `protected` methods.
- Changing a member's access can silently change which overload wins in derived code.

## See also

- [[encapsulation]]
- [[inheritance]]
- [[friend-functions-classes]]
