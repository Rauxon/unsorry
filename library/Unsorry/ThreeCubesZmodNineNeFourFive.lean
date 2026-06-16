import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
theorem three_cubes_zmod_nine_ne_four_five (a b c : ℤ) :
    ((a ^ 3 + b ^ 3 + c ^ 3 : ℤ) : ZMod 9) ≠ 4 ∧
    ((a ^ 3 + b ^ 3 + c ^ 3 : ℤ) : ZMod 9) ≠ 5 := by
  first
    | (push_cast; generalize (a : ZMod 9) = z0; generalize (b : ZMod 9) = z1; generalize (c : ZMod 9) = z2; revert z0 z1 z2; decide)
    | (generalize (a : ZMod 9) = z0; generalize (b : ZMod 9) = z1; generalize (c : ZMod 9) = z2; revert z0 z1 z2; decide)
    | (push_cast; decide)
    | decide
