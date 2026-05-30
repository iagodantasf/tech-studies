---
title: Stacks & queues
track: computer-science
group: Data structures
tags: [cs, data-structures, stacks, queues]
prerequisites: [arrays-and-dynamic-arrays, linked-lists]
see-also: [trees, graphs]
---

# Stacks & queues

Stacks and queues are **access-discipline** data structures: they restrict *where* you add and remove
elements. A **stack** is LIFO (last in, first out); a **queue** is FIFO (first in, first out).

## Why it matters

The restriction is the feature. By only allowing one end, you get O(1) operations and a model that
matches countless real problems: a stack mirrors function call frames, undo history, and expression
evaluation; a queue mirrors task schedulers, buffers, and breadth-first traversal. Both back core
algorithms — DFS uses a stack, BFS uses a queue (see [[graphs]]).

## How it works

Either can be built on an [[arrays-and-dynamic-arrays|array]] or a [[linked-lists|linked list]].

**Stack** — push/pop at the top:
```
push(x): data.append(x)
pop():    return data.removeLast()
peek():   return data.last
```

**Queue** — enqueue at the back, dequeue at the front. A naive array makes dequeue O(n) (shifting),
so use a **circular buffer** (head/tail indices wrapping around) or a doubly linked list for O(1):
```
enqueue(x): data[tail] = x; tail = (tail+1) % cap
dequeue():  x = data[head]; head = (head+1) % cap; return x
```

| | Stack | Queue |
|---|---|---|
| Add | push (top) | enqueue (back) |
| Remove | pop (top) | dequeue (front) |
| Order | LIFO | FIFO |
| All ops | O(1) | O(1) |

Variants: a **deque** allows O(1) at both ends; a **priority queue** removes by priority, not arrival
order — that's a [[heaps-and-priority-queues|heap]].

## Example

Balanced-parenthesis check — the canonical stack problem:

```
function balanced(s):
    stack ← empty
    for c in s:
        if c is an opener: stack.push(c)
        else if c is a closer:
            if stack.empty() or not matches(stack.pop(), c): return false
    return stack.empty()
```

## Pitfalls

- **Queue on a plain array** — dequeuing from the front by shifting is O(n); use a circular buffer or
  linked list.
- **Underflow** — popping/dequeuing an empty structure; guard with `isEmpty`.
- **Stack overflow** — deep recursion *is* an implicit stack; very deep recursion blows the call
  stack. Convert to an explicit stack + loop when depth is unbounded.

## See also

- [[heaps-and-priority-queues]]
- [[graphs]]
