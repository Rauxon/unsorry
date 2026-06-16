import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

/-- The square of `ab + bc + ca` dominates `3abc(a + b + c)`.

Writing `x = ab`, `y = bc`, `z = ca`, the right-hand side is `3(xy + yz + zx)`
and the left-hand side is `(x + y + z)^2`; their difference is
`((x-y)^2 + (y-z)^2 + (z-x)^2) / 2`, a sum of squares. `nlinarith` closes the
goal from those three witnesses. -/
theorem pair_sum_sq_ge_three_abc_sum (a b c : ℝ) :
    (a*b + b*c + c*a)^2 ≥ 3 * (a*b*c) * (a + b + c) := by
  nlinarith [sq_nonneg (a*b - b*c), sq_nonneg (b*c - c*a), sq_nonneg (c*a - a*b)]
