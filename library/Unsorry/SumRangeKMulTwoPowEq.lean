import Mathlib

theorem sum_range_k_mul_two_pow_eq (n : ℕ) :
    ∑ k ∈ Finset.range n, (k : ℤ) * 2 ^ k = (n - 2) * 2 ^ n + 2 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    ring
