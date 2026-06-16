import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
theorem sum_two_squares_zmod_four_ne_three (a b : ℤ) : (((a ^ 2 + b ^ 2 : ℤ)) : ZMod 4) ≠ 3 := by
  first
    | (push_cast; generalize (a : ZMod 4) = z0; generalize (b : ZMod 4) = z1; revert z0 z1; decide)
    | (generalize (a : ZMod 4) = z0; generalize (b : ZMod 4) = z1; revert z0 z1; decide)
    | (push_cast; decide)
    | decide
