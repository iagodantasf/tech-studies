---
title: Operating systems
track: computer-science
group: Systems
tags: [cs, systems, os]
prerequisites: [computer-architecture]
see-also: [concurrency-and-deadlocks, computer-architecture]
---

# Operating systems

An operating system is the layer that multiplexes the CPU, memory, and devices across many
**processes**, giving each the illusion of its own machine.

## Why it matters

Every program you write runs on top of these abstractions — when you fork a worker, `mmap` a file,
or hit a page fault, you're calling into the OS. Knowing how scheduling and virtual memory behave
explains otherwise-mysterious latency spikes, out-of-memory kills, and why context switches are not
free.

## How it works

A **process** is an isolated address space plus resources; a **thread** is a unit of execution that
shares its process's address space with sibling threads. Threads are cheap to create and switch but
share memory, which is exactly where [[concurrency-and-deadlocks|concurrency]] bugs come from.

**Scheduling** decides who runs next on each core:

- **Round-robin** — equal time slices, simple and fair.
- **Priority / multi-level feedback** — interactive jobs get boosted, CPU-bound jobs drift down.
- A **context switch** saves one thread's registers and restores another's — cheap in cycles, but it
  also pollutes the cache (see [[computer-architecture]]).

**Virtual memory** gives every process a private linear address space. The MMU translates virtual
pages to physical **frames** via page tables, cached in the **TLB**. Touching an unmapped page raises
a **page fault**; if RAM is full the OS **swaps** a page to disk — orders of magnitude slower.

A **system call** (`read`, `write`, `fork`) traps from user mode into the kernel, the only code
allowed to touch hardware directly.

## Example

```
pid = fork()              # child gets a copy-on-write clone of the address space
if pid == 0:
    exec("/bin/worker")   # replace the image; pages fault in lazily on first use
else:
    wait(pid)             # parent blocks until the child exits
```

Copy-on-write means `fork` is cheap: pages are shared read-only until one side writes.

## Pitfalls

- **Leaking processes/threads** — orphaned children become zombies; always `wait`/`join`.
- **Assuming memory is RAM** — a "fast" array can silently live in swap and fault on every access.
- **Busy-waiting** — spinning instead of blocking burns a whole CPU and starves other work; block on
  the kernel instead.

## See also

- [[computer-architecture]]
- [[concurrency-and-deadlocks]]
