import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_910_pow_fifteen_sub_pow_three (n : ℤ) : (910 : ℤ) ∣ n ^ 15 - n ^ 3 := by
  have h : ((n ^ 15 - n ^ 3 : ℤ) : ZMod 910) = 0 := by
    push_cast
    have : ∀ m : ZMod 910, m ^ 15 - m ^ 3 = 0 := by decide
    exact this (n : ZMod 910)
  rwa [ZMod.intCast_zmod_eq_zero_iff_dvd] at h