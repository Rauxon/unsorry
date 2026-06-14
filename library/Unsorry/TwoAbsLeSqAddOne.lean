import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

theorem two_abs_le_sq_add_one (x : ℝ) : 2 * |x| ≤ x ^ 2 + 1 := by
  nlinarith [sq_nonneg (|x| - 1), sq_abs x]
