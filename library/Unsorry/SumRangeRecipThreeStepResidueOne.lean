import Mathlib

/-!
# Telescoping sum with a three-step residue-one denominator

This module proves a closed form for the partial sums of the series whose
`k`-th term is `3 / ((3k+1)(3k+4))`.  The terms telescope as
`1/(3k+1) - 1/(3k+4)`, so the partial sum over `Finset.range n` collapses to
`1 - 1/(3n+1)`.
-/

theorem sum_range_recip_three_step_residue_one (n : ℕ) :
    ∑ k ∈ Finset.range n, (3 : ℚ) / ((3 * (k : ℚ) + 1) * (3 * (k : ℚ) + 4))
      = 1 - 1 / (3 * (n : ℚ) + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    have h1 : (3 * (m : ℚ) + 1) ≠ 0 := by positivity
    have h2 : (3 * (m : ℚ) + 4) ≠ 0 := by positivity
    push_cast
    have h3 : (3 * ((m : ℚ) + 1) + 1) ≠ 0 := by positivity
    field_simp
    ring
