# not-prime-pow-four-add-four

For every natural n with n > 1, n^4 + 4 is not prime, via the Sophie Germain factorization n^4+4 = (n^2-2n+2)(n^2+2n+2).

- **Source:** classic identities
- **Reference:** Sophie Germain's identity, compositeness corollary. Sierpiński, Elementary Theory of Numbers (PWN/North-Holland, 1988); standard olympiad result.
- **Absence:** machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities
- **Difficulty:** 3
- **Decomposition sketch:** L1: instantiate pow_four_add_four_mul_pow_four with b=1 to get n^4+4 = (n^2-2n+2)*(n^2+2n+2). Watch ℕ subtraction — may need an ℤ instantiation or rewrite (n^2-2n+2 = (n-1)^2+1) to keep it well-defined. L2: show 1 < n^2-2n+2 when n>1 (both factors nontrivial, neither equals 1). L3: nontrivial factor
