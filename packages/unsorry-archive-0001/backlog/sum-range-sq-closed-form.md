# sum-range-sq-closed-form

For every natural n, 6 * (sum of i^2 for i in 0..n) = n(n+1)(2n+1), the integer form of 1^2+...+n^2 = n(n+1)(2n+1)/6.

- **Source:** classic identities
- **Reference:** Faulhaber's formula, case p=2 (square pyramidal number). Apostol, Calculus Vol. 1, 2nd ed., §I.4.2; Graham, Knuth & Patashnik, Concrete Mathematics, §2.5; Avigad/Massot, Mathematics in Lean, §5…
- **Absence:** machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities
- **Difficulty:** 2
- **Decomposition sketch:** Single induction on n. Base n=0 trivial. Step via Finset.sum_range_succ then ring/ring_nf on 6*(prev) + 6*(n+1)^2 = (n+1)(n+2)(2n+3). No sub-lemmas needed. Risk: general Bernoulli sum_range_pow exists but does NOT give this elementary closed form directly (Bernoulli/ℚ form), so this is a genuine sta
