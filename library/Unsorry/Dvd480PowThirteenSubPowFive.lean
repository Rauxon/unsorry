import Mathlib

set_option maxRecDepth 20000 in
theorem dvd_480_pow_thirteen_sub_pow_five (n : ℤ) : (480 : ℤ) ∣ n ^ 13 - n ^ 5 := by
  have h : ((n ^ 13 - n ^ 5 : ℤ) : ZMod 480) = 0 := by
    push_cast
    have : ∀ x : ZMod 480, x ^ 13 - x ^ 5 = 0 := by decide
    exact this (n : ZMod 480)
  have := (ZMod.intCast_zmod_eq_zero_iff_dvd (n ^ 13 - n ^ 5) 480).mp h
  exact_mod_cast this