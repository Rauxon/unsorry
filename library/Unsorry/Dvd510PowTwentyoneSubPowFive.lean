import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_510_pow_twentyone_sub_pow_five (n : ℤ) : (510 : ℤ) ∣ n ^ 21 - n ^ 5 := by
  have key : ∀ m : ZMod 510, m ^ 21 - m ^ 5 = 0 := by decide
  apply (ZMod.intCast_zmod_eq_zero_iff_dvd (n ^ 21 - n ^ 5) 510).mp
  push_cast
  exact key (n : ZMod 510)