import Mathlib

/-- The partial sums of `1 / ((k+1)(k+2)(k+3))` telescope to a closed form. -/
theorem sum_range_recip_triple_consecutive (n : ℕ) :
    ∑ k ∈ Finset.range n, (1 : ℚ) / (((k : ℚ) + 1) * ((k : ℚ) + 2) * ((k : ℚ) + 3))
      = 1 / 4 - 1 / (2 * ((n : ℚ) + 1) * ((n : ℚ) + 2)) := by
  induction n with
  | zero => norm_num
  | succ m ih =>
      rw [Finset.sum_range_succ, ih]
      have h1 : ((m : ℚ) + 1) ≠ 0 := by positivity
      have h2 : ((m : ℚ) + 2) ≠ 0 := by positivity
      have h3 : ((m : ℚ) + 3) ≠ 0 := by positivity
      push_cast
      field_simp
      ring
