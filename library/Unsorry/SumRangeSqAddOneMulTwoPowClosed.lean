import Mathlib

theorem sum_range_sq_add_one_mul_two_pow_closed (n : ℕ) : ∑ k ∈ Finset.range n, ((k : ℤ) ^ 2 + 1) * 2 ^ k = ((n : ℤ) ^ 2 - 4 * n + 7) * 2 ^ n - 7 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    ring