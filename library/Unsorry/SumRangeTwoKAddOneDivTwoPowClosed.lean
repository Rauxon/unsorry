import Mathlib

theorem sum_range_two_k_add_one_div_two_pow_closed (n : ℕ) : (∑ k ∈ Finset.range n, (2 * (k : ℚ) + 1) / 2 ^ k) = 6 - (4 * (n : ℚ) + 6) / 2 ^ n := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    have h2 : (2 : ℚ) ^ m ≠ 0 := by positivity
    push_cast
    field_simp
    ring