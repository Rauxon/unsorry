import Mathlib

theorem sum_two_squares_zmod_eight_ne_six (m n : ℤ) : (((m ^ 2 + n ^ 2 : ℤ)) : ZMod 8) ≠ 6 := by
  push_cast
  generalize (m : ZMod 8) = a
  generalize (n : ZMod 8) = b
  revert a b
  decide