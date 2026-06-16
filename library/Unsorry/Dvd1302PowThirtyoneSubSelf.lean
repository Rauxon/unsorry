import Mathlib

set_option maxRecDepth 40000 in
theorem dvd_1302_pow_thirtyone_sub_self (n : ℤ) : (1302 : ℤ) ∣ n ^ 31 - n := by
  have h : ((1302 : ℤ) ∣ n ^ 31 - n) ↔ ((n : ZMod 1302) ^ 31 - n = 0) := by
    rw [sub_eq_zero]
    constructor
    · intro hd
      have := (ZMod.intCast_zmod_eq_zero_iff_dvd (n ^ 31 - n) 1302).mpr hd
      push_cast at this
      linear_combination this
    · intro he
      have : ((n ^ 31 - n : ℤ) : ZMod 1302) = 0 := by push_cast; linear_combination he
      exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ _).mp this
  rw [h]
  generalize (n : ZMod 1302) = x
  revert x
  decide