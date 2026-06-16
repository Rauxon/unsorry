import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_252_pow_eight_sub_sq (n : ℤ) : (252 : ℤ) ∣ n ^ 8 - n ^ 2 := by
  have h : ((n ^ 8 - n ^ 2 : ℤ) : ZMod 252) = 0 := by
    push_cast
    have : ∀ x : ZMod 252, x ^ 8 - x ^ 2 = 0 := by decide
    exact this _
  rwa [ZMod.intCast_zmod_eq_zero_iff_dvd] at h