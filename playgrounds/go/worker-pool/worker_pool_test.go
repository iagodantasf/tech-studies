package main

import (
	"sync/atomic"
	"testing"
)

func TestPoolSquares(t *testing.T) {
	in := []int{1, 2, 3, 4, 5}
	want := []int{1, 4, 9, 16, 25}
	got := Pool(in, 3, func(n int) int { return n * n })
	if len(got) != len(want) {
		t.Fatalf("len = %d, want %d", len(got), len(want))
	}
	for i := range want {
		if got[i] != want[i] {
			t.Errorf("got[%d] = %d, want %d", i, got[i], want[i])
		}
	}
}

func TestPoolPreservesOrder(t *testing.T) {
	in := make([]int, 100)
	for i := range in {
		in[i] = i
	}
	got := Pool(in, 8, func(n int) int { return n })
	for i := range in {
		if got[i] != i {
			t.Fatalf("order broken at %d: got %d", i, got[i])
		}
	}
}

func TestPoolRunsEveryJob(t *testing.T) {
	in := make([]int, 50)
	var count atomic.Int64
	Pool(in, 5, func(n int) int {
		count.Add(1)
		return n
	})
	if got := count.Load(); got != 50 {
		t.Errorf("ran %d jobs, want 50", got)
	}
}

func TestPoolZeroWorkersDefaultsToOne(t *testing.T) {
	got := Pool([]int{2, 3}, 0, func(n int) int { return n + 1 })
	if got[0] != 3 || got[1] != 4 {
		t.Errorf("got %v, want [3 4]", got)
	}
}
