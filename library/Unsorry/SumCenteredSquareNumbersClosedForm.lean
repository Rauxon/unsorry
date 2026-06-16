import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.Ring

theorem sum_centered_square_numbers_closed_form (n : ℕ) :
    3 * ∑ k ∈ Finset.range n, (2 * k * (k + 1) + 1) = n * (2 * n ^ 2 + 1) := by
  induction n with
  | zero =>
      simp
  | succ n ih =>
      rw [Finset.sum_range_succ]
      calc
        3 * (∑ k ∈ Finset.range n, (2 * k * (k + 1) + 1) + (2 * n * (n + 1) + 1)) =
            3 * ∑ k ∈ Finset.range n, (2 * k * (k + 1) + 1) + 3 * (2 * n * (n + 1) + 1) := by
          ring
        _ = n * (2 * n ^ 2 + 1) + 3 * (2 * n * (n + 1) + 1) := by
          rw [ih]
        _ = (n + 1) * (2 * (n + 1) ^ 2 + 1) := by
          ring
