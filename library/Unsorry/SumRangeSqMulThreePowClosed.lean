import Mathlib

theorem sum_range_sq_mul_three_pow_closed (n : ℕ) : 2 * ∑ k ∈ Finset.range n, ((k : ℤ) ^ 2) * 3 ^ k = ((n : ℤ) ^ 2 - 3 * n + 3) * 3 ^ n - 3 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    push_cast
    ring