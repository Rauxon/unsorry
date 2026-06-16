import Mathlib.Data.ZMod.Basic

theorem three_dvd_pow_three_add_five_mul (n : ℤ) : (3 : ℤ) ∣ n ^ 3 + 5 * n := by
  have h : ((n ^ 3 + 5 * n : ℤ) : ZMod 3) = 0 := by
    simpa using (by decide : ∀ x : ZMod 3, x ^ 3 + 5 * x = 0) (n : ZMod 3)
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd (n ^ 3 + 5 * n) 3).mp h
