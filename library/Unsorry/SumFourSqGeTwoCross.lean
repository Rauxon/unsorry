import Mathlib

-- This module proves the inequality `2 * a * b + 2 * c * d ≤ a ^ 2 + b ^ 2 + c ^ 2 + d ^ 2` for real numbers `a, b, c, d`. The proof relies on standard algebraic manipulations and inequalities.

theorem sum_four_sq_ge_two_cross (a b c d : ℝ) : 2 * a * b + 2 * c * d ≤ a ^ 2 + b ^ 2 + c ^ 2 + d ^ 2 := by
  -- The inequality can be rewritten as:
  -- `a^2 + b^2 + c^2 + d^2 - 2*a*b - 2*c*d ≥ 0`
  -- This is equivalent to:
  -- `(a - b)^2 + (c - d)^2 ≥ 0`
  have h1 : (a - b) ^ 2 ≥ 0 := by apply sq_nonneg
  have h2 : (c - d) ^ 2 ≥ 0 := by apply sq_nonneg
  -- The sum of two non-negative terms is also non-negative
  linarith