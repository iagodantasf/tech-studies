// Package main demonstrates a worker pool: a fixed number of goroutines
// draining a jobs channel concurrently, with results collected back in order.
//
// Part of the tech-studies Go playground (see playgrounds/README.md).
// Motivating node: System Design → Asynchronism / task queues.
package main

import (
	"fmt"
	"sync"
)

// Pool runs fn over every input using `workers` goroutines and returns the
// results in the same order as inputs. It's a minimal bounded-concurrency
// task queue: a jobs channel feeds the workers, a WaitGroup waits for drain.
//
// Each result index is written by exactly one goroutine and read only after
// Wait(), so no mutex is needed around the results slice.
func Pool[T, R any](inputs []T, workers int, fn func(T) R) []R {
	if workers < 1 {
		workers = 1
	}
	type job struct {
		idx int
		in  T
	}
	jobs := make(chan job)
	results := make([]R, len(inputs))

	var wg sync.WaitGroup
	for w := 0; w < workers; w++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for j := range jobs {
				results[j.idx] = fn(j.in)
			}
		}()
	}
	for i, in := range inputs {
		jobs <- job{idx: i, in: in}
	}
	close(jobs)
	wg.Wait()
	return results
}

func main() {
	nums := []int{1, 2, 3, 4, 5, 6, 7, 8}
	squares := Pool(nums, 3, func(n int) int { return n * n })
	fmt.Println("inputs: ", nums)
	fmt.Println("squares:", squares)
}
