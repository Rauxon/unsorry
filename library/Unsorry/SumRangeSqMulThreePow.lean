import Mathlib

theorem sum_range_sq_mul_three_pow (n : ℕ) : 2 * (∑ k ∈ Finset.range n, (k:ℤ)^2 * 3^k) + 3 = 3^n * ((n:ℤ)^2 - 3*n + 3) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ]
    push_cast
    push_cast at ih
    ring_nf
    ring_nf at ih
    nlinarith [ih]