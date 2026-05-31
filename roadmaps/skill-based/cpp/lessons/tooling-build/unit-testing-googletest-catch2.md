---
title: "Unit Testing (GoogleTest, Catch2)"
track: cpp
group: Tooling & Build
tags: [cpp, testing]
prerequisites: [build-systems-cmake-make, assertions]
see-also: [build-systems-cmake-make, static-analysis-clang-tidy-cppcheck, sanitizers-asan-ubsan-tsan]
---

# Unit Testing (GoogleTest, Catch2)

GoogleTest and Catch2 are C++ frameworks for writing and running automated unit tests, providing assertion macros, test discovery, fixtures, and result reporting.

## Why it matters

Tests are the executable specification that lets you refactor and add features without silently breaking behavior — critical in C++ where undefined behavior makes regressions subtle. A test suite wired into [[build-systems-cmake-make|CMake]]/CTest runs in CI on every commit, and pairing it with [[sanitizers-asan-ubsan-tsan|sanitizers]] turns each test into a memory- and race-checker. GoogleTest dominates large codebases; Catch2 is popular for its header-only, low-ceremony style.

## How it works

You write `TEST(...)`/`TEST_CASE(...)` blocks containing assertions; the framework auto-registers them, runs each in isolation, and reports pass/fail with the offending values.

| Concept | GoogleTest | Catch2 |
|---|---|---|
| Define a test | `TEST(Suite, Name)` | `TEST_CASE("name")` |
| Fatal assert | `ASSERT_EQ(a,b)` | `REQUIRE(a == b)` |
| Non-fatal assert | `EXPECT_EQ(a,b)` | `CHECK(a == b)` |
| Shared setup | fixture class + `TEST_F` | `SECTION`s |
| Setup model | explicit fixtures | nested sections re-run body |

- **`ASSERT_*`/`REQUIRE` abort the current test on failure; `EXPECT_*`/`CHECK` log and continue** — use EXPECT/CHECK so one test reports all its failures, ASSERT/REQUIRE only when later lines would crash.
- Catch2 has **no separate fixture class**: each `SECTION` re-executes the test body from the top, so setup code before the sections runs fresh per section — a fork-per-leaf model.
- GoogleTest fixtures (`TEST_F`) share `SetUp()`/`TearDown()`; `TEST_P` parameterizes over a value set, and **GoogleMock** adds mock objects (`EXPECT_CALL`) for interaction testing.
- Integrate with `enable_testing()` + `gtest_discover_tests(target)` (or `catch_discover_tests`) so `ctest` runs them; in CI run a second pass built with `-fsanitize=address,undefined`.

## Example

```cpp
#include <gtest/gtest.h>
int add(int a, int b);

TEST(MathTest, HandlesNegatives) {
  EXPECT_EQ(add(-2, 3), 1);     // logs and continues if wrong
  ASSERT_NE(add(2, 2), 5);      // aborts this test if it fails
}
```

```cmake
find_package(GTest REQUIRED)
add_executable(tests math_test.cpp)
target_link_libraries(tests PRIVATE GTest::gtest_main core)
gtest_discover_tests(tests)     # ctest now sees each TEST
```

`ctest --output-on-failure` runs the suite and prints the expected-vs-actual for any failure.

## Pitfalls

- **`ASSERT_*` in a helper (non-void) function** doesn't return from the *test* — only from the helper — so execution continues unexpectedly; check `HasFatalFailure()` or use EXPECT.
- **Floating-point `EXPECT_EQ`** fails on rounding; use `EXPECT_NEAR`/`Approx` with a tolerance instead of exact equality.
- **Order-dependent tests** that share global/static state pass alone but fail when run together or shuffled (`--gtest_shuffle`); keep each test self-contained.
- **Death tests / threading**: `ASSERT_DEATH` and multithreaded tests are fork/timing-sensitive and flaky if shared state isn't isolated.

## See also

- [[build-systems-cmake-make]]
- [[static-analysis-clang-tidy-cppcheck]]
- [[sanitizers-asan-ubsan-tsan]]
