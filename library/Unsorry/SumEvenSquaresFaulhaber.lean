import Mathlib

theorem sum_even_squares_faulhaber (n : ℕ) : 3 * ∑ k ∈ Finset.range (n + 1), (2 * k) ^ 2 = 2 * n * (n + 1) * (2 * n + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    ring
