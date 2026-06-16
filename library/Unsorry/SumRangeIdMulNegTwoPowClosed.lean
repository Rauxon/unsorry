import Mathlib

theorem sum_range_id_mul_neg_two_pow_closed (n : ℕ) : 9 * ∑ k ∈ Finset.range n, (k : ℤ) * (-2) ^ k = (2 - 3 * (n : ℤ)) * (-2) ^ n - 2 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, mul_add, ih, pow_succ]
    push_cast
    ring