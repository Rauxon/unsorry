import Mathlib

theorem sum_k_mul_k_add_two_closed_form (n : ℕ) : 6 * ∑ k ∈ Finset.range (n + 1), k * (k + 2) = n * (n + 1) * (2 * n + 7) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    ring