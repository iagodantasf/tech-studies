---
title: Rust
track: rust
category: Skill-based
tags: [roadmap, rust]
---

# Rust

> roadmap.sh: https://roadmap.sh/rust

Suggested path through the **Rust** nodes. Each node links to its lesson when written.

## Nodes

### Introduction
- What is Rust
- Why Rust (Safety / Performance)
- Installing Rust (rustup)
- `rustc` & the Toolchain
- Hello World
- Cargo Basics
- Rust Editions

### Language Basics
- Variables & Mutability
- Constants & Shadowing
- Scalar Types
- Compound Types (Tuples, Arrays)
- Functions
- Comments & Doc Comments
- Control Flow (`if` / `loop` / `while` / `for`)
- Statements vs Expressions

### Ownership & Borrowing
- Ownership Rules
- Move Semantics
- Clone vs Copy
- References & Borrowing
- Mutable References
- Slices
- The Borrow Checker
- Lifetimes
- Lifetime Elision

### Compound & Custom Types
- Structs
- Tuple & Unit Structs
- Enums
- Pattern Matching (`match`)
- `if let` / `let else` / `while let`
- Methods & Associated Functions
- `impl` Blocks

### Error Handling
- `Option<T>`
- `Result<T, E>`
- The `?` Operator
- `panic!` & Unrecoverable Errors
- Custom Error Types
- `thiserror` / `anyhow`

### Generics & Traits
- Generic Functions & Types
- Traits
- Trait Bounds
- Default Implementations
- Trait Objects & Dynamic Dispatch
- Associated Types
- Operator Overloading
- Derive Macros
- Marker Traits (Send / Sync / Sized)

### Collections & Strings
- `Vec<T>`
- `String` vs `&str`
- `HashMap` / `BTreeMap`
- `HashSet` / `BTreeSet`
- `VecDeque`
- Iterators
- Iterator Adapters (map / filter / collect)
- Closures

### Smart Pointers
- `Box<T>`
- `Rc<T>` / `Arc<T>`
- `RefCell<T>` & Interior Mutability
- `Cell<T>`
- `Deref` & `Drop`
- Reference Cycles & `Weak<T>`

### Concurrency
- Threads (`std::thread`)
- `move` Closures
- Message Passing (channels)
- Shared State (`Mutex` / `RwLock`)
- `Send` & `Sync` Revisited
- Atomics
- Async / Await
- Futures & Executors (tokio / async-std)

### Modules & Crates
- Modules & Paths
- `pub` & Visibility
- `use` Declarations
- Packages vs Crates
- Workspaces
- Crates.io & Dependencies
- Semantic Versioning

### Advanced
- Unsafe Rust
- Raw Pointers
- FFI (calling C)
- Declarative Macros (`macro_rules!`)
- Procedural Macros
- Advanced Traits (Supertraits, Newtype)
- `const` Generics
- Zero-Cost Abstractions

### Tooling & Ecosystem
- Cargo (build / run / check)
- `rustfmt`
- Clippy
- `cargo test` & Testing
- Documentation Tests
- Benchmarking
- `cargo doc`
- Debugging (gdb / lldb)
- Publishing a Crate

## Resources
See [resources.md](./resources.md).

## Project ideas
- Extend `playgrounds/rust/` with a new `cli-grep` member crate (`cargo new --bin cli-grep`) that reads a file, filters lines by a pattern, and exercises `Result`, the `?` operator, and iterator adapters.
- Add a `threadpool` crate to the workspace that builds a fixed-size worker pool with `std::thread` + channels — the Rust mirror of the Go `worker-pool` playground — to internalize `Send`/`Sync` and `Arc<Mutex<…>>`.
- Generalize the existing `playgrounds/rust/binary-search` into a generic `fn binary_search<T: Ord>(…)` with trait bounds and a full set of `#[test]` cases plus a doc test.
