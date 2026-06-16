import Mathlib

set_option maxRecDepth 100000 in
theorem dvd_910_pow_twentyfive_sub_pow_thirteen (n : ℤ) :
    (910 : ℤ) ∣ n^25 - n^13 := by
  have h : ((n^25 - n^13 : ℤ) : ZMod 910) = 0 → (910 : ℤ) ∣ n^25 - n^13 := by
    intro hk
    have := (ZMod.intCast_zmod_eq_zero_iff_dvd (n^25 - n^13) 910).1 hk
    simpa using this
  apply h
  push_cast
  generalize (n : ZMod 910) = m
  revert m
  decide