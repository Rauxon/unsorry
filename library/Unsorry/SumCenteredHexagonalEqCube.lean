import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.Ring

/-- The sum of the first `n` centered hexagonal numbers `3 * k ^ 2 + 3 * k + 1`
equals `n ^ 3`, proved by telescoping induction. -/
theorem sum_centered_hexagonal_eq_cube (n : ℕ) :
    ∑ k ∈ Finset.range n, (3 * k ^ 2 + 3 * k + 1) = n ^ 3 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    ring
