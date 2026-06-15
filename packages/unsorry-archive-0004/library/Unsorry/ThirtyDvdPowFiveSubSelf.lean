import Mathlib.Data.ZMod.Basic

theorem thirty_dvd_pow_five_sub_self (n : ℤ) : (30 : ℤ) ∣ n ^ 5 - n := by
  have h1 : ((n ^ 5 - n : ℤ) : ZMod 30) = (n : ZMod 30) ^ 5 - (n : ZMod 30) := by push_cast; rfl
  have h2 : ∀ (m : ZMod 30), m ^ 5 - m = 0 := by decide
  have h3 : ((n ^ 5 - n : ℤ) : ZMod 30) = 0 := by
    rw [h1, h2 (n : ZMod 30)]
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd (n ^ 5 - n) 30).mp h3
