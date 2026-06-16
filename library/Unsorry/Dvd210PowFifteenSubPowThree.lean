import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_210_pow_fifteen_sub_pow_three (n : ℤ) : (210 : ℤ) ∣ n ^ 15 - n ^ 3 := by
  have : (210 : ℤ) = ((210 : ℕ) : ℤ) := by norm_num
  rw [this, ← ZMod.intCast_zmod_eq_zero_iff_dvd]
  push_cast
  generalize (n : ZMod 210) = x
  revert x
  decide
