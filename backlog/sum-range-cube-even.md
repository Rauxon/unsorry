# sum-range-cube-even

For every natural n, the sum of the cubes of the first n even numbers equals 2n²(n−1)²; i.e. (2·0)³+2³+4³+…+(2(n−1))³ = 2n²(n−1)².

- **Source:** classic identities (power-sum tower — compounds on `nicomachus-sum-cubes`)
- **Reference:** Even-cube sums ∑(2k)³ = 8∑k³ = 8·(n(n−1)/2)²; immediate corollary of Nicomachus's theorem (∑k³ = (∑k)²) scaled by 8. CRC Standard Mathematical Tables (sums of powers); companion of the proved `sum-range-cube-odd`.
- **Absence:** machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-13)
- **Difficulty:** 2
- **Decomposition sketch:** ∑(2i)³ = 8·∑i³; reuse the library lemma `nicomachus-sum-cubes` (∑i³ = (∑i)²) plus the Gauss sum ∑_{i<n} i = n(n−1)/2, then ring. Or direct induction on n over Finset.sum_range_succ (step is a polynomial identity; n=0,1 close the (n−1)² truncation). 1–2 steps. **This is the first compounding rung: it stands on a proved library theorem rather than mathlib alone.**
