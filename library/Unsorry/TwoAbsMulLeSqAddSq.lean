import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

theorem two_abs_mul_le_sq_add_sq (a b : ℝ) : 2 * |a * b| ≤ a ^ 2 + b ^ 2 := by
  have h1 : 0 ≤ (|a| - |b|) ^ 2 := sq_nonneg (|a| - |b|)
  have h2 : |a * b| = |a| * |b| := abs_mul a b
  have h3 : |a| ^ 2 = a ^ 2 := sq_abs a
  have h4 : |b| ^ 2 = b ^ 2 := sq_abs b
  have h5 : (|a| - |b|) ^ 2 = |a| ^ 2 - 2 * (|a| * |b|) + |b| ^ 2 := by ring
  linarith
