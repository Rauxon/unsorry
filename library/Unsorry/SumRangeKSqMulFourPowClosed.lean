import Mathlib

theorem sum_range_k_sq_mul_four_pow_closed (n : ℕ) :
    27 * ∑ k ∈ Finset.range n, (k : ℤ)^2 * 4^k
      = 4^n * (9 * (n:ℤ)^2 - 24 * n + 20) - 20 := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    push_cast
    ring