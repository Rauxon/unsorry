import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_504_pow_nine_sub_pow_three (n : ℤ) : (504 : ℤ) ∣ n ^ 9 - n ^ 3 := by
  have h : ((n ^ 9 - n ^ 3 : ℤ) : ZMod 504) = 0 := by
    push_cast
    have : ∀ x : ZMod 504, x ^ 9 - x ^ 3 = 0 := by decide
    exact this n
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ _).mp h