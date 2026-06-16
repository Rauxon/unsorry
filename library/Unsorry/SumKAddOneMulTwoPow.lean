import Mathlib

theorem sum_k_add_one_mul_two_pow (n : ℕ) : ∑ k ∈ Finset.range n, ((k : ℤ) + 1) * 2 ^ k = ((n : ℤ) - 1) * 2 ^ n + 1 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    ring