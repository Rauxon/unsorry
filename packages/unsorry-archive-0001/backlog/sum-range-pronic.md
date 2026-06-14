# sum-range-pronic

For every natural n, 3 * (sum of i(i+1) for i in 0..n) = n(n+1)(n+2); the sum of the first pronic (oblong) numbers, equivalently 2 * C(n+2, 3).

- **Source:** classic identities
- **Reference:** Pronic/oblong number sums ∑k(k+1) = n(n+1)(n+2)/3; Graham, Knuth & Patashnik, Concrete Mathematics, Ch. 2; CRC Standard Mathematical Tables (figurate numbers).
- **Absence:** machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-12)
- **Difficulty:** 2
- **Decomposition sketch:** Induction on n over Finset.range (n+1) with Finset.sum_range_succ; the step is a cubic polynomial identity closed by ring (no truncated subtraction anywhere). 1 step.
