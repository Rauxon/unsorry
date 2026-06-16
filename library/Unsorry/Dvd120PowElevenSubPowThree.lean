import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_120_pow_eleven_sub_pow_three (n : ℤ) : (120 : ℤ) ∣ n ^ 11 - n ^ 3 := by
  have key : ∀ m : ZMod 120, m ^ 11 - m ^ 3 = 0 := by decide
  have h : ((n ^ 11 - n ^ 3 : ℤ) : ZMod 120) = 0 := by
    push_cast
    exact key _
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ 120).mp h