# sum-range-odd-eq-sq

For every natural n, the sum over i in 0..n-1 of (2i+1) equals n^2 (i.e. 1+3+5+...+(2n-1) = n^2).

- **Source:** classic identities
- **Reference:** Classical 'gnomon' identity (sum of consecutive odd numbers is a perfect square). Graham, Knuth & Patashnik, Concrete Mathematics, 2nd ed., §2.5; Rosen, Discrete Mathematics and Its Applications, 7th…
- **Absence:** machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities
- **Difficulty:** 1
- **Decomposition sketch:** Single induction on n. Base n=0 trivial. Step via Finset.sum_range_succ then ring/omega: n^2 + (2n+1) = (n+1)^2. No sub-lemmas. Optional Post⊆Pre edge: factor as 2*(∑ k) + n then apply existing Finset.sum_range_id.
