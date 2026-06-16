import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_282_pow_fortyseven_sub_self (n : ℤ) :
    (282 : ℤ) ∣ (n^47 - n) := by
  have key : ∀ m : ZMod 282, m^47 - m = 0 := by decide
  have h282 : (282 : ℤ) = ((282 : ℕ) : ℤ) := by norm_num
  rw [h282, ← ZMod.intCast_zmod_eq_zero_iff_dvd]
  push_cast
  exact key _