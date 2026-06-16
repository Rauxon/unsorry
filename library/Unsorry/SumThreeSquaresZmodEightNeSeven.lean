import Mathlib

theorem sum_three_squares_zmod_eight_ne_seven (a b c : ℤ) : (((a ^ 2 + b ^ 2 + c ^ 2 : ℤ)) : ZMod 8) ≠ 7 := by
  have h : (((a ^ 2 + b ^ 2 + c ^ 2 : ℤ)) : ZMod 8)
      = (a : ZMod 8) ^ 2 + (b : ZMod 8) ^ 2 + (c : ZMod 8) ^ 2 := by
    push_cast; ring
  rw [h]
  generalize (a : ZMod 8) = x
  generalize (b : ZMod 8) = y
  generalize (c : ZMod 8) = z
  revert x y z
  decide