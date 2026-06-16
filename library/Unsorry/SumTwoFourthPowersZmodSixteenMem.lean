import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
theorem sum_two_fourth_powers_zmod_sixteen_mem (a b : ℤ) : (((a ^ 4 + b ^ 4 : ℤ)) : ZMod 16) = 0 ∨ (((a ^ 4 + b ^ 4 : ℤ)) : ZMod 16) = 1 ∨ (((a ^ 4 + b ^ 4 : ℤ)) : ZMod 16) = 2 := by
  first
    | (push_cast; generalize (a : ZMod 16) = z0; generalize (b : ZMod 16) = z1; revert z0 z1; decide)
    | (generalize (a : ZMod 16) = z0; generalize (b : ZMod 16) = z1; revert z0 z1; decide)
    | (push_cast; decide)
    | decide
