import Mathlib

theorem sum_range_sq_mul_four_pow_closed (n : ℕ) : 27 * ∑ k ∈ Finset.range n, ((k : ℤ) ^ 2) * 4 ^ k = (9 * (n : ℤ) ^ 2 - 24 * n + 20) * 4 ^ n - 20 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    push_cast
    ring