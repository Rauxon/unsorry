import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_66_pow_thirtyone_sub_pow_eleven (n : ℤ) :
    (66 : ℤ) ∣ (n^31 - n^11) := by
  have key : ((n^31 - n^11 : ℤ) : ZMod 66) = 0 := by
    push_cast
    have : ∀ x : ZMod 66, x^31 - x^11 = 0 := by decide
    exact this _
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ 66).mp key