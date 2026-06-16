import Mathlib

theorem sum_centered_tetrahedral_closed_form (n : ℕ) :
    2 * ∑ k ∈ Finset.range n, (2 * (k:ℤ) + 1) * ((k:ℤ)^2 + k + 3)
      = (n:ℤ)^2 * ((n:ℤ)^2 + 5) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    push_cast
    ring