import Mathlib

set_option maxRecDepth 100000 in
theorem dvd_798_pow_thirtyseven_sub_pow_nineteen (n : ℤ) :
    (798 : ℤ) ∣ n^37 - n^19 := by
  have h : ((n^37 - n^19 : ℤ) : ZMod 798) = 0 := by
    push_cast
    have : ∀ x : ZMod 798, x^37 - x^19 = 0 := by decide
    simpa using this (n : ZMod 798)
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd (n^37 - n^19) 798).mp h