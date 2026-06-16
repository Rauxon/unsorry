import Mathlib

theorem two_dvd_pow_three_add_five_mul (n : ℤ) : (2 : ℤ) ∣ n ^ 3 + 5 * n := by
  suffices h : ((n ^ 3 + 5 * n : ℤ) : ZMod 2) = 0 by
    exact_mod_cast (ZMod.intCast_zmod_eq_zero_iff_dvd (n ^ 3 + 5 * n) 2).mp h
  push_cast
  generalize (n : ZMod 2) = x
  revert x
  decide
