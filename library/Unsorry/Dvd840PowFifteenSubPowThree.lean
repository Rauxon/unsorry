import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_840_pow_fifteen_sub_pow_three (n : ℤ) : (840 : ℤ) ∣ n ^ 15 - n ^ 3 := by
  suffices h : ((n ^ 15 - n ^ 3 : ℤ) : ZMod 840) = 0 by
    rwa [ZMod.intCast_zmod_eq_zero_iff_dvd] at h
  push_cast
  generalize (n : ZMod 840) = x
  revert x
  decide