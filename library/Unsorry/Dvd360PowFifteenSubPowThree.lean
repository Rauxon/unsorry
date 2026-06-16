import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_360_pow_fifteen_sub_pow_three (n : ℤ) : (360 : ℤ) ∣ n ^ 15 - n ^ 3 := by
  have h : ((n ^ 15 - n ^ 3 : ℤ) : ZMod 360) = 0 → (360 : ℤ) ∣ n ^ 15 - n ^ 3 := by
    intro hh
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ 360).mp hh
  apply h
  push_cast
  have : ∀ m : ZMod 360, m ^ 15 - m ^ 3 = 0 := by decide
  exact this _