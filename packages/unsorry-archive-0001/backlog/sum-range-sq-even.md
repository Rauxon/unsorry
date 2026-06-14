# sum-range-sq-even

For every natural n, 3 * (sum of (2i)^2 for i in 0..n-1) = 2n(n-1)(2n-1); the sum of the squares of the first n even numbers 0^2 + 2^2 + ... + (2n-2)^2 in closed form.

- **Source:** classic identities
- **Reference:** Even-square sums ∑(2k)^2 = 2m(m+1)(2m+1)/3 (here reindexed from 0); CRC Standard Mathematical Tables (sums of powers); companion of the proved sum-range-sq-odd-closed-form.
- **Absence:** machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-12)
- **Difficulty:** 2
- **Decomposition sketch:** Direct induction on n with Finset.sum_range_succ; the step is a polynomial identity dischargeable by ring after clearing the n-1 and 2n-1 truncated subtractions (rewrite at n+1 where both are truncation-free; n = 0 closes by rfl). 1-2 steps.
