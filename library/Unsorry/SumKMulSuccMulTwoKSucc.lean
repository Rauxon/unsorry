import Mathlib

theorem sum_k_mul_succ_mul_two_k_succ (n : ℕ) : 2 * ∑ k ∈ Finset.range (n + 1), k * (k + 1) * (2 * k + 1) = n * (n + 1) ^ 2 * (n + 2) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    ring