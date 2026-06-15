import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

/-- A completed-square expression with a nonnegative residual term is nonnegative. -/
theorem completed_square_form_nonneg (a b c x : ℝ) (hdisc : b ^ 2 ≤ 4 * a * c) :
    0 ≤ (2 * a * x + b) ^ 2 + (4 * a * c - b ^ 2) := by
  have h1 : 0 ≤ (2 * a * x + b) ^ 2 := sq_nonneg _
  have h2 : 0 ≤ 4 * a * c - b ^ 2 := by linarith
  linarith
