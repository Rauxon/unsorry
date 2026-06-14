# alternating-sum-naturals

For every natural n, the sum over i in 0..n-1 of (-1)^i (i+1) equals -(n/2) if n is even and (n/2)+1 if n is odd (integer division over ℤ).

- **Source:** classic identities
- **Reference:** Standard arithmetic alternating-series partial sums (1-2+3-4+...); tabulated in Hardy, Divergent Series, Ch. 1; elementary induction exercise in discrete-math texts.
- **Absence:** machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities
- **Difficulty:** 3
- **Decomposition sketch:** Two-step induction (n → n+2) collapsing each pair (-1)^i(i+1)+(-1)^(i+1)(i+2) = -1; base cases n=0,1. Reconcile Even/(n/2) with Nat.div via omega. ~3 sub-parts — the Even/ℕ-division bookkeeping is the only real friction (riskiest to PROVE of the set, though statement is type-confirmed).
