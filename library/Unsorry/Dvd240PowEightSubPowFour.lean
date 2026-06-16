import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_240_pow_eight_sub_pow_four (n : ℤ) : (240 : ℤ) ∣ n ^ 8 - n ^ 4 := by
  have key : ∀ m : ZMod 240, m ^ 8 - m ^ 4 = 0 := by decide
  have := key (n : ZMod 240)
  have h0 : ((n ^ 8 - n ^ 4 : ℤ) : ZMod 240) = 0 := by push_cast; simpa using this
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ 240).mp h0