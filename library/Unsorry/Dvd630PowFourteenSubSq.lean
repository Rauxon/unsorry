import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_630_pow_fourteen_sub_sq (n : ℤ) : (630 : ℤ) ∣ n ^ 14 - n ^ 2 := by
  have h : ∀ m : ZMod 630, m ^ 14 - m ^ 2 = 0 := by decide
  have := h (n : ZMod 630)
  have : ((n ^ 14 - n ^ 2 : ℤ) : ZMod 630) = 0 := by
    push_cast
    simpa using h (n : ZMod 630)
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ _).mp this