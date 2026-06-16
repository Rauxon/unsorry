import Mathlib

theorem sum_centered_square_numbers_closed_form (n : ℕ) : 3 * ∑ k ∈ Finset.range n, (2 * k * (k + 1) + 1) = n * (2 * n ^ 2 + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    ring