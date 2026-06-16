import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
theorem sum_two_cubes_zmod_nine_ne_four (m n : ℤ) : (((m ^ 3 + n ^ 3 : ℤ)) : ZMod 9) ≠ 4 := by
  first
    | (push_cast; generalize (m : ZMod 9) = z0; generalize (n : ZMod 9) = z1; revert z0 z1; decide)
    | (generalize (m : ZMod 9) = z0; generalize (n : ZMod 9) = z1; revert z0 z1; decide)
    | (push_cast; decide)
    | decide
