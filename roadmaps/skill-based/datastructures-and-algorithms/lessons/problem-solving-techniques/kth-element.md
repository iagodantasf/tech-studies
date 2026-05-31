---
title: Kth Element
track: datastructures-and-algorithms
group: Problem-solving techniques
tags: [datastructures-and-algorithms, problem-solving]
prerequisites: [heap, quick-sort]
see-also: [heap, quick-sort, sorting-algorithms]
---

# Kth Element

Find the k-th smallest/largest item (or the top k) without fully sorting — using a size-k [[heaps-and-priority-queues]] for streams or Quickselect for arrays, both beating the O(n log n) sort.

## Why it matters

"Top k", "k-th largest", "k closest points", and median-of-a-stream are everywhere: leaderboards, k-nearest-neighbors, percentile metrics, load-shedding the heaviest k requests. Sorting throws away work — you do not need the other n−k in order. A bounded heap gives O(n log k), and Quickselect gives O(n) average, so for k ≪ n the speedup is large and the memory (O(k)) is small enough to run over an unbounded stream.

## How it works

Pick by whether data is a fixed array or a stream, and whether you need the single k-th or the whole top-k set:

| Method | Time | Space | Best when |
|---|---|---|---|
| Sort then index | O(n log n) | O(1)+ | tiny n, or you need full order anyway |
| Min-heap of size k | O(n log k) | O(k) | streaming / huge n, want top-k |
| Quickselect | O(n) avg, O(n²) worst | O(1) | static array, want only the k-th |

```text
heap = min-heap()                     # top-k LARGEST via a MIN-heap
for x in stream:
    push(heap, x)
    if size(heap) > k: pop_min(heap)  # evict smallest -> k biggest remain
return peek(heap)                     # heap top = k-th largest
```

- Counter-intuitive but key: top-k **largest** uses a **min**-heap (the root is the weakest survivor, cheap to evict).
- Quickselect partitions like [[sorting]] but recurses into only the side holding index k, halving work each step → O(n) average.

## Example

3rd-largest of `[3, 2, 1, 5, 6, 4]`, k=3. Maintain a min-heap capped at 3: after `3,2,1` heap=`{1,2,3}`. Push 5 → evict 1 → `{2,3,5}`. Push 6 → evict 2 → `{3,5,6}`. Push 4 → evict 3 → `{4,5,6}`. Root = 4, the 3rd largest. Quickselect would instead partition around a pivot and dive only toward index n−k.

## Pitfalls

- **Wrong heap polarity:** largest-k needs a min-heap, smallest-k needs a max-heap — flipping it evicts the wrong element and returns garbage.
- **Quickselect's O(n²) worst case** on sorted input with a bad pivot; randomize the pivot (or use median-of-medians) to keep it linear.
- **Quickselect mutates and partially reorders the array** in place — copy first if the caller still needs the original order.
- **Off-by-one between "k-th" and index k−1**, and confusing 1-based "k-th largest" with 0-based array offsets.

## See also

- [[heaps-and-priority-queues]]
- [[sorting]]
- [[sorting]]
