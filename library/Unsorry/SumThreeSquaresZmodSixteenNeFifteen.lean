import Mathlib

theorem sum_three_squares_zmod_sixteen_ne_fifteen (a b c : ℤ) : (((a ^ 2 + b ^ 2 + c ^ 2 : ℤ)) : ZMod 16) ≠ 15 := by
  have key : ∀ x y z : ZMod 16, x ^ 2 + y ^ 2 + z ^ 2 ≠ 15 := by decide
  push_cast
  exact key a b c