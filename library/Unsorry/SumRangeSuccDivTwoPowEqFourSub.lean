import Mathlib

theorem sum_range_succ_div_two_pow_eq_four_sub (n : ℕ) : ∑ k ∈ Finset.range n, ((k : ℚ) + 1) / 2 ^ k = 4 - (2 * (n : ℚ) + 4) / 2 ^ n := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    have h : (2 : ℚ) ^ m ≠ 0 := by positivity
    field_simp
    ring