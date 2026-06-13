# sum-range-pow-six-closed-form

For every natural n, 42·(sum of i⁶ for i in 0..n) = n(n+1)(2n+1)(3n⁴+6n³−3n+1); Faulhaber's closed form for sixth powers, ∑k⁶ = (6n⁷+21n⁶+21n⁵−7n³+n)/42.

- **Source:** classic identities (power-sum tower — the next rung above proved p=2..p=5)
- **Reference:** Faulhaber's formula, p = 6; Conway & Guy, The Book of Numbers (sums of powers); D. E. Knuth, "Johann Faulhaber and sums of powers", Math. Comp. 61 (1993); CRC Standard Mathematical Tables.
- **Absence:** machine-checked; the `i ^ 6` pattern flags only the Weierstrass ℘-function file (Analysis/SpecialFunctions/Elliptic), verified unrelated — no specific sixth-power Faulhaber closed form present. mathlib carries only the general Bernoulli-number formula (`NumberTheory/Bernoulli.lean`, over ℚ), not this factored ℕ closed form — the same precedent under which the proved `sum-range-pow-four-closed-form` and `sum-range-pow-five-closed-form` were admitted (rev c5ea00351c28, 2026-06-13).
- **Difficulty:** 3
- **Decomposition sketch:** Induction on n over Finset.range (n+1) with Finset.sum_range_succ, mirroring the proved pow-four/pow-five goals; the step is a degree-7 polynomial identity closed by ring after rewriting 3(n+1)⁴+6(n+1)³−3(n+1)+1 to avoid the truncated subtraction (n=0 closes by rfl). 1–2 steps.
