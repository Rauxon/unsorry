# sum-range-pow-four-closed-form

For every natural n, 30 * (sum of k^4 for k in 0..n) = n(n+1)(2n+1)(3n^2+3n-1), the integer (ℤ) form of the Faulhaber p=4 identity.

- **Source:** classic identities
- **Reference:** Faulhaber's formula, case p=4. Conway & Guy, The Book of Numbers, Ch. 2; Knuth, 'Johann Faulhaber and sums of powers', Math. Comp. 61 (1993).
- **Absence:** machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities
- **Difficulty:** 2
- **Decomposition sketch:** Induction on n over ℤ. Base n=0 (both sides 0). Step via Finset.sum_range_succ then ring closes the polynomial identity. PRE-FLIGHT: before admission, confirm Finset.sum_range_pow specialization doesn't trivialize it; if it does, downgrade to a corollary-application rather than a fresh induction.
