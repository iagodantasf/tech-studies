//! Binary search experiment for the Computer Science track.
//! Notes: ../../../roadmaps/computer-science/notes/binary-search.md

/// Returns the index of `target` in the sorted slice `xs`, or `None`.
/// Half-open range `[lo, hi)` — the shape with the fewest off-by-one traps.
fn binary_search<T: Ord>(xs: &[T], target: &T) -> Option<usize> {
    let (mut lo, mut hi) = (0, xs.len());
    while lo < hi {
        let mid = lo + (hi - lo) / 2; // avoids lo+hi overflow
        match xs[mid].cmp(target) {
            std::cmp::Ordering::Less => lo = mid + 1,
            std::cmp::Ordering::Greater => hi = mid,
            std::cmp::Ordering::Equal => return Some(mid),
        }
    }
    None
}

fn main() {
    let xs: Vec<i32> = (0..20).map(|x| x * 2).collect(); // 0,2,4,...,38
    for t in [0, 14, 38, 7, 40] {
        println!("search {t:>2} -> {:?}", binary_search(&xs, &t));
    }
}

#[cfg(test)]
mod tests {
    use super::binary_search;

    #[test]
    fn finds_present() {
        let xs = [1, 3, 5, 7, 9];
        for (i, v) in xs.iter().enumerate() {
            assert_eq!(binary_search(&xs, v), Some(i));
        }
    }

    #[test]
    fn rejects_absent() {
        let xs = [1, 3, 5, 7, 9];
        for v in [0, 2, 8, 10] {
            assert_eq!(binary_search(&xs, &v), None);
        }
    }

    #[test]
    fn handles_empty() {
        let xs: [i32; 0] = [];
        assert_eq!(binary_search(&xs, &1), None);
    }
}
