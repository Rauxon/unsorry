import Mathlib

set_option maxRecDepth 40000 in
theorem dvd_1023_pow_thirtyone_sub_self (n : ℤ) : (1023 : ℤ) ∣ n ^ 31 - n := by
  have h : ((n ^ 31 - n : ℤ) : ZMod 1023) = 0 := by
    push_cast
    have : ∀ x : ZMod 1023, x ^ 31 - x = 0 := by decide
    exact this _
  rwa [ZMod.intCast_zmod_eq_zero_iff_dvd] at h