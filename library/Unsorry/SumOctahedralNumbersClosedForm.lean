import Mathlib

theorem sum_octahedral_numbers_closed_form (n : ℕ) : 6 * ∑ k ∈ Finset.range (n + 1), k * (2 * k ^ 2 + 1) = 3 * n * (n + 1) * (n ^ 2 + n + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    ring