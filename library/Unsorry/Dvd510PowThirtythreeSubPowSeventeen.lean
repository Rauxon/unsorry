import Mathlib

set_option maxRecDepth 20000 in
theorem dvd_510_pow_thirtythree_sub_pow_seventeen (n : ℤ) : (510 : ℤ) ∣ n ^ 33 - n ^ 17 := by
  have h : ((n ^ 33 - n ^ 17 : ℤ) : ZMod 510) = 0 := by
    push_cast
    have : ∀ x : ZMod 510, x ^ 33 - x ^ 17 = 0 := by decide
    exact this _
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ 510).mp h