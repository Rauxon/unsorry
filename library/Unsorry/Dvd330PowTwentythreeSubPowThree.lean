import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_330_pow_twentythree_sub_pow_three (n : ℤ) :
    (330 : ℤ) ∣ n ^ 23 - n ^ 3 := by
  have h : ((330 : ℤ) : ZMod 330) = 0 := by decide
  suffices hz : ∀ m : ZMod 330, m ^ 23 - m ^ 3 = 0 by
    have := hz (n : ZMod 330)
    have hcast : ((n ^ 23 - n ^ 3 : ℤ) : ZMod 330) = 0 := by
      push_cast
      simpa using this
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ _).mp hcast
  decide