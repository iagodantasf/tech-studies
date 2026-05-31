---
title: Running First Program
track: cpp
group: Introduction
tags: [cpp, basics]
prerequisites: [setting-up-the-environment, compilers-gcc-clang-msvc]
see-also: [how-c-works-compilation-model, input-output-iostream]
---

# Running First Program

The canonical "hello world" — an `int main()` that prints a line — exercises the full edit → compile → link → run loop and confirms the toolchain works end to end.

## Why it matters

This is the smoke test for your whole setup ([[setting-up-the-environment]]): if it compiles and runs, your compiler, standard library, linker, and `PATH` are all wired correctly. It also introduces three things you'll use forever — `#include`, the special `main` function, and stream output via [[input-output-iostream]].

## How it works

`main` is the program's entry point; the OS calls it, and its **return value is the process exit code** (0 = success, nonzero = failure — visible to shells and CI).

- `#include <iostream>` pulls in declarations for `std::cout` and `std::endl`.
- `std::cout << x` chains because `operator<<` returns the stream by reference.
- `return 0;` is **optional in `main` only** — falling off the end implicitly returns 0; every other non-`void` function must return.

| Phase | Command (GCC) | Produces |
|---|---|---|
| Compile + link | `g++ -std=c++20 hello.cpp -o hello` | executable `hello` |
| Run | `./hello` | stdout text |
| Check exit code | `echo $?` | `0` |

## Example

```cpp
#include <iostream>

int main() {
    std::cout << "Hello, world!" << '\n';
    return 0;   // exit code 0 = success
}
```

```bash
$ g++ -std=c++20 -Wall hello.cpp -o hello
$ ./hello
Hello, world!
$ echo $?          # the exit code main returned
0
```

Prefer `'\n'` over `std::endl` here: `std::endl` also **flushes** the buffer, which is needless overhead per line in tight loops.

## Pitfalls

- **`void main()`** is non-standard — the signature is `int main()` or `int main(int argc, char** argv)`. Some compilers tolerate `void`; don't rely on it.
- **Forgetting `std::`** — `cout` without `using` or qualification won't compile; avoid `using namespace std;` in headers (it leaks names).
- **`#include <iostream.h>`** — the `.h` form is a pre-standard header that no longer exists; use `<iostream>`.
- **Running before compiling succeeds** — a missing linker step (only `-c`) yields an `.o`, not a runnable binary.

## See also

- [[how-c-works-compilation-model]]
- [[input-output-iostream]]
