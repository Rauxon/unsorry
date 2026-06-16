import Mathlib

theorem sum_range_k_sq_mul_five_pow_closed (n : ℕ) :
    32 * ∑ k ∈ Finset.range n, (k : ℤ)^2 * 5^k
      = (8 * (n : ℤ)^2 - 20 * n + 15) * 5^n - 15 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    push_cast
    ring