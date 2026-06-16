import Mathlib

theorem sum_range_two_k_sub_one_mul_three_pow_closed (n : ℕ) : ∑ k ∈ Finset.range n, (2 * (k : ℤ) - 1) * 3 ^ k = ((n : ℤ) - 2) * 3 ^ n + 2 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    ring