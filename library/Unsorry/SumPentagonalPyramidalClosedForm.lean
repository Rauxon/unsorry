import Mathlib

theorem sum_pentagonal_pyramidal_closed_form (n : ℕ) : 12 * ∑ k ∈ Finset.range (n + 1), k ^ 2 * (k + 1) = n * (n + 1) * (3 * n + 1) * (n + 2) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    ring
