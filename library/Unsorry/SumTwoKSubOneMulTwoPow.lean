import Mathlib

theorem sum_two_k_sub_one_mul_two_pow (n : ℕ) : ∑ k ∈ Finset.range n, ((2 * (k : ℤ) - 1)) * 2 ^ k = (2 * (n : ℤ) - 5) * 2 ^ n + 5 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    ring