# sum-range-sq-odd-closed-form

For every natural n, 3 * (sum of (2i+1)^2 for i in 0..n-1) = n(2n-1)(2n+1); i.e. 1^2+3^2+...+(2n-1)^2 = n(2n-1)(2n+1)/3.

- **Source:** classic identities
- **Reference:** Standard finite-sum identity ∑(2k-1)^2 = n(2n-1)(2n+1)/3; Concrete Mathematics §2.5 exercises; Gradshteyn & Ryzhik, Table of Integrals, Series, and Products (sums section).
- **Absence:** machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities
- **Difficulty:** 2
- **Decomposition sketch:** Direct induction on n with Finset.sum_range_succ. Inductive step is a polynomial identity dischargeable by ring after clearing the 2*n-1 truncated subtraction (handle n=0 separately, or rewrite 2*(n+1)-1 = 2*n+1 which avoids truncation in the step). 1-2 steps.
