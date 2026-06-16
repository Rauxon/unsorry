import Mathlib

theorem sum_two_cubes_zmod_seven_mem (a b : ℤ) : (((a ^ 3 + b ^ 3 : ℤ)) : ZMod 7) ≠ 3 ∧ (((a ^ 3 + b ^ 3 : ℤ)) : ZMod 7) ≠ 4 := by
  have h : (((a ^ 3 + b ^ 3 : ℤ)) : ZMod 7) = (a : ZMod 7) ^ 3 + (b : ZMod 7) ^ 3 := by
    push_cast
    ring
  rw [h]
  generalize (a : ZMod 7) = x
  generalize (b : ZMod 7) = y
  revert x y
  decide