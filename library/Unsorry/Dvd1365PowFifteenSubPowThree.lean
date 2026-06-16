import Mathlib

set_option maxRecDepth 100000 in
theorem dvd_1365_pow_fifteen_sub_pow_three (n : ℤ) : (1365 : ℤ) ∣ n ^ 15 - n ^ 3 := by
  have hd : ∀ (k : ℕ), (∀ a : ZMod k, a ^ 15 - a ^ 3 = 0) → (k : ℤ) ∣ n ^ 15 - n ^ 3 := by
    intro k hk
    have : ((n ^ 15 - n ^ 3 : ℤ) : ZMod k) = 0 := by
      push_cast
      have := hk (n : ZMod k)
      simpa using this
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ _).mp this
  have h3 : (3 : ℤ) ∣ n ^ 15 - n ^ 3 := by
    have := hd 3 (by decide); simpa using this
  have h5 : (5 : ℤ) ∣ n ^ 15 - n ^ 3 := by
    have := hd 5 (by decide); simpa using this
  have h7 : (7 : ℤ) ∣ n ^ 15 - n ^ 3 := by
    have := hd 7 (by decide); simpa using this
  have h13 : (13 : ℤ) ∣ n ^ 15 - n ^ 3 := by
    have := hd 13 (by decide); simpa using this
  -- combine via coprimality
  have c35 : (15 : ℤ) ∣ n ^ 15 - n ^ 3 := by
    have : IsCoprime (3 : ℤ) 5 := by
      rw [Int.isCoprime_iff_gcd_eq_one]; decide
    have h15 := this.mul_dvd h3 h5
    simpa using h15
  have c357 : (105 : ℤ) ∣ n ^ 15 - n ^ 3 := by
    have : IsCoprime (15 : ℤ) 7 := by
      rw [Int.isCoprime_iff_gcd_eq_one]; decide
    have := this.mul_dvd c35 h7
    simpa using this
  have c : (1365 : ℤ) ∣ n ^ 15 - n ^ 3 := by
    have : IsCoprime (105 : ℤ) 13 := by
      rw [Int.isCoprime_iff_gcd_eq_one]; decide
    have := this.mul_dvd c357 h13
    simpa using this
  exact c