import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Ring

theorem add_sq_ge_four_mul_real (a b : ℝ) : 4 * (a * b) ≤ (a + b) ^ 2 := by
  calc
    4 * (a * b) ≤ 4 * (a * b) + (a - b) ^ 2 := le_add_of_nonneg_right (sq_nonneg (a - b))
    _ = (a + b) ^ 2 := by ring
