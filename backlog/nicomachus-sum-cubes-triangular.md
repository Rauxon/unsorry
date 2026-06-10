# nicomachus-sum-cubes-triangular

For every natural n, the sum over i in 0..n of i^3 equals (n(n+1)/2)^2 (the explicit triangular-number form of Nicomachus' theorem).

- **Source:** Freek 100 / classic
- **Reference:** Nicomachus of Gerasa, Introduction to Arithmetic, Book II, in explicit closed form; Graham, Knuth & Patashnik, Concrete Mathematics, §2.5 (∑k^3 = (n(n+1)/2)^2).
- **Absence:** machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities
- **Difficulty:** 3
- **Decomposition sketch:** Path A: prove the Nicomachus form ∑ i^3 = (∑ i)^2 (mirror the active goal), then rewrite ∑ i over range(n+1) as n(n+1)/2 via the Finset.sum_range_id closed form. Path B: direct induction, but the ℕ division means you must discharge 2 ∣ n*(n+1) via Nat.even_mul_succ_self so squaring commutes with /2.
