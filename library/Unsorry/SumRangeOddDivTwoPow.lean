import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic

/-- The closed form for the partial sums of `(2 i + 1) / 2 ^ i` over the rationals. -/
theorem sum_range_odd_div_two_pow (n : ℕ) :
    ∑ i ∈ Finset.range (n + 1), (2 * i + 1 : ℚ) / 2 ^ i = 6 - (2 * n + 5) / 2 ^ n := by
  induction n with
  | zero => norm_num
  | succ k ih =>
      rw [Finset.sum_range_succ, ih]
      have h2 : (2 : ℚ) ^ k ≠ 0 := by positivity
      push_cast
      field_simp
      ring
