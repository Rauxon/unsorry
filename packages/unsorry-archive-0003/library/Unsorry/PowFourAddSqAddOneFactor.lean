import Mathlib.Algebra.Ring.Basic
import Mathlib.Tactic.Ring

/-- The Sophie Germain–style factorisation of `n^4 + n^2 + 1` over the integers. -/
theorem pow_four_add_sq_add_one_factor (n : ℤ) :
    n ^ 4 + n ^ 2 + 1 = (n ^ 2 + n + 1) * (n ^ 2 - n + 1) := by
  ring
