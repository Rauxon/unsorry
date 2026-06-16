import Mathlib

theorem six_dvd_pow_three_add_five_mul (n : ℤ) : (6 : ℤ) ∣ n ^ 3 + 5 * n := by
  have key : ∀ m : ZMod 6, m ^ 3 + 5 * m = 0 := by decide
  have : ((n ^ 3 + 5 * n : ℤ) : ZMod 6) = 0 := by
    push_cast
    exact key _
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ 6).mp this