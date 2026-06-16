import Mathlib

theorem sum_even_index_triangular_closed_form (n : ℕ) : 6 * ∑ k ∈ Finset.range (n + 1), k * (2 * k + 1) = n * (n + 1) * (4 * n + 5) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    ring
