import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_240_pow_nine_sub_pow_five (n : ℤ) : (240 : ℤ) ∣ n ^ 9 - n ^ 5 := by
  have key : ∀ x : ZMod 240, x ^ 9 - x ^ 5 = 0 := by decide
  have h : ((n ^ 9 - n ^ 5 : ℤ) : ZMod 240) = 0 := by
    push_cast
    exact key _
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ 240).mp h