import Mathlib

theorem sum_range_two_k_add_one_mul_two_pow_closed (n : ℕ) : ∑ k ∈ Finset.range (n + 1), ((2 * k + 1) * 2 ^ k : ℤ) = (2 * n - 1) * 2 ^ (n + 1) + 3 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    ring