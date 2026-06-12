# sum-range-cube-odd

For every natural n, the sum of the cubes of the first n odd numbers equals n^2 * (2n^2 - 1); i.e. 1^3 + 3^3 + ... + (2n-1)^3 = n^2(2n^2 - 1).

- **Source:** classic identities
- **Reference:** Standard finite-sum identity ∑(2k-1)^3 = n^2(2n^2-1); CRC Standard Mathematical Tables (sums of powers of odd integers); Gradshteyn & Ryzhik, Table of Integrals, Series, and Products (sums section).
- **Absence:** machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-12)
- **Difficulty:** 2
- **Decomposition sketch:** Direct induction on n with Finset.sum_range_succ. Inductive step is a polynomial identity dischargeable by ring after rewriting 2*(n+1)^2 - 1 = 2*n^2 + 4*n + 1 to avoid truncated subtraction (n = 0 closes both sides to 0). 1-2 steps.
