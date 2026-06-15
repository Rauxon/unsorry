import Mathlib.Data.ZMod.Basic

theorem twelve_dvd_pow_four_sub_sq (n : ℤ) : (12 : ℤ) ∣ n ^ 4 - n ^ 2 := by
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd (n ^ 4 - n ^ 2) 12).mp <| by
    simpa using (by decide : ∀ a : ZMod 12, a ^ 4 - a ^ 2 = 0) (n : ZMod 12)
