import Mathlib

theorem sum_range_id_mul_three_pow_closed (n : ℕ) : 4 * ∑ k ∈ Finset.range n, (k : ℤ) * 3 ^ k = (2 * (n : ℤ) - 3) * 3 ^ n + 3 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    push_cast
    ring