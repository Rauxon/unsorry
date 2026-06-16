import Mathlib

theorem three_cubes_zmod_nine_ne_four_five (a b c : ℤ) :
    ((a ^ 3 + b ^ 3 + c ^ 3 : ℤ) : ZMod 9) ≠ 4 ∧
    ((a ^ 3 + b ^ 3 + c ^ 3 : ℤ) : ZMod 9) ≠ 5 := by
  push_cast
  generalize (a : ZMod 9) = x
  generalize (b : ZMod 9) = y
  generalize (c : ZMod 9) = z
  revert x y z
  decide