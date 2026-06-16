import Mathlib

theorem sum_centered_octahedral_closed_form (n : ℕ) :
    ∑ k ∈ Finset.range n, (2 * k + 1) * (2 * k ^ 2 + 2 * k + 3) = n ^ 2 * (n ^ 2 + 2) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    ring
