---
title: "Condition Variables"
track: cpp
group: Concurrency
tags: [cpp, condition-variables]
prerequisites: [mutexes-locks, threads-std-thread]
see-also: [mutexes-locks, atomics, std-async-futures-promises, memory-model-data-races]
---

# Condition Variables

A condition variable (`<condition_variable>`) lets a thread **sleep until another thread signals** that some predicate became true, without busy-waiting.

## Why it matters

It is the standard tool for producer/consumer queues, thread pools, and "wait until ready" handoffs. The alternative — spinning in a `while(!ready){}` loop — burns a whole core and adds latency. A condition variable parks the thread in the kernel at ~zero cost until a `notify` wakes it, which is why every bounded work queue is built on one.

## How it works

A `std::condition_variable` always pairs with a `std::mutex` and a **predicate** (the real shared condition). `wait()` atomically *unlocks the mutex and sleeps*, then *re-locks before returning* — closing the race where the signal could slip between the check and the sleep.

| Call | Effect |
|---|---|
| `cv.wait(lock, pred)` | sleep while `!pred()`; re-checks on each wake |
| `cv.wait_for(lock, dur, pred)` | as above, bounded by a timeout |
| `cv.notify_one()` | wake one waiter |
| `cv.notify_all()` | wake all waiters |

- The waiter needs a `std::unique_lock<std::mutex>` (not `lock_guard`), because the CV must unlock and relock it.
- **Always use the predicate overload** (`wait(lk, pred)`); it loops internally, defeating *spurious wakeups* — wakes that occur with no notify, which the standard explicitly permits.
- The thread that changes the state should **mutate under the lock, then notify**. Notifying without holding the lock is legal but risks a lost wakeup if the predicate is set non-atomically.
- `notify_one` wakes a single waiter (use for one-item-one-consumer); `notify_all` is needed when the new state can satisfy several waiters or different predicates.

## Example

A thread-safe queue handoff:

```cpp
std::mutex m; std::condition_variable cv; std::queue<int> q;

void producer(int v) {
  { std::lock_guard lg(m); q.push(v); }   // mutate under lock
  cv.notify_one();                        // then wake a consumer
}
int consumer() {
  std::unique_lock lk(m);
  cv.wait(lk, [&]{ return !q.empty(); }); // sleeps; re-locks on return
  int v = q.front(); q.pop();
  return v;                               // lock released at scope end
}
```

If `consumer` used a bare `cv.wait(lk)` with no predicate, a spurious wake or a notify that arrived before the wait would pop an empty queue — UB.

## Pitfalls

- **Predicate-less `wait`** breaks on spurious wakeups and lost notifications. Never omit the predicate.
- **Lost wakeup:** if you set the flag *without* the mutex and the waiter checks the predicate just before `wait` sleeps, the `notify` is missed and the thread sleeps forever. Mutate under the lock.
- **`notify_one` with heterogeneous waiters** can wake a thread whose predicate is still false, leaving the right one asleep — use `notify_all` when predicates differ.
- **Wrong lock type:** `wait` requires `unique_lock`; passing a `lock_guard` will not compile.

## See also

- [[mutexes-locks]]
- [[std-async-futures-promises]]
- [[atomics]]
