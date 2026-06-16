import Mathlib

theorem sum_range_recip_two_pow (n : ℕ) : ∑ i ∈ Finset.range n, (1 : ℚ) / 2 ^ i = 2 - 2 / 2 ^ n := by
  induction n with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ, ih, pow_succ]
    field_simp
    ring