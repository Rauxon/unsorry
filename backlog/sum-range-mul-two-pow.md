# sum-range-mul-two-pow

For every natural n, the sum over i in 0..n-1 of i * 2^i equals (n - 2) * 2^n + 2 (stated over ℤ, where the right side is negative-free for all n).

- **Source:** classic identities
- **Reference:** Arithmetico-geometric sum ∑k·2^k = (n-2)·2^n + 2; Graham, Knuth & Patashnik, Concrete Mathematics, §2.5 (the perturbation-method worked example ∑k·2^k).
- **Absence:** machine-checked no-local-match for the weighted closed form (grep of pinned mathlib rev c5ea00351c28, 2026-06-12); mathlib's generic geometric-sum machinery (Algebra/Ring/GeomSum) covers ∑x^k but not the k-weighted sum.
- **Difficulty:** 2
- **Decomposition sketch:** Induction on n with Finset.sum_range_succ over ℤ; the step is a ring identity after push_cast (the ℤ codomain avoids ℕ truncation in (n-2)). 1-2 steps.
