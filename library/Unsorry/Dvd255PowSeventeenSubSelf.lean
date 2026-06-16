import Mathlib

set_option maxRecDepth 20000 in
theorem dvd_255_pow_seventeen_sub_self (n : ℤ) : (255 : ℤ) ∣ n ^ 17 - n := by
  have key : ∀ x : ZMod 255, x ^ 17 - x = 0 := by decide
  have : ((n ^ 17 - n : ℤ) : ZMod 255) = 0 := by
    push_cast
    exact key _
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ 255).mp this