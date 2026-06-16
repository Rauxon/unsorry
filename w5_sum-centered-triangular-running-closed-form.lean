import Mathlib

theorem sum_centered_triangular_running_closed_form (n : ℕ) : ∑ k ∈ Finset.range n, (3 * k ^ 2 + 3 * k + 2) = n * (n ^ 2 + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    ring
