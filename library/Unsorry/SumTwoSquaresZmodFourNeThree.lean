import Mathlib

theorem sum_two_squares_zmod_four_ne_three (a b : ℤ) : (((a ^ 2 + b ^ 2 : ℤ)) : ZMod 4) ≠ 3 := by
  have h : ((a ^ 2 + b ^ 2 : ℤ) : ZMod 4) = (a : ZMod 4) ^ 2 + (b : ZMod 4) ^ 2 := by
    push_cast
    ring
  rw [h]
  generalize (a : ZMod 4) = x
  generalize (b : ZMod 4) = y
  revert x y
  decide