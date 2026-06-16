import Mathlib

theorem sum_range_id_div_two_pow (n : ℕ) : ∑ i ∈ Finset.range (n + 1), (i : ℚ) / 2 ^ i = 2 - (n + 2) / 2 ^ n := by
  induction n with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    field_simp
    ring