import Mathlib

set_option maxRecDepth 100000 in
theorem dvd_870_pow_twentynine_sub_self (n : ℤ) : (870 : ℤ) ∣ n^29 - n := by
  have key : ∀ (p : ℕ), (∀ x : ZMod p, x^29 - x = 0) → (p : ℤ) ∣ n^29 - n := by
    intro p hp
    rw [← ZMod.intCast_zmod_eq_zero_iff_dvd]
    push_cast
    exact hp _
  have h2 : (2 : ℤ) ∣ n^29 - n := key 2 (by decide)
  have h3 : (3 : ℤ) ∣ n^29 - n := key 3 (by decide)
  have h5 : (5 : ℤ) ∣ n^29 - n := key 5 (by decide)
  have h29 : (29 : ℤ) ∣ n^29 - n := key 29 (by decide)
  -- combine: 870 = 2*3*5*29, pairwise coprime
  have c615 : (6 : ℤ) ∣ n^29 - n := by
    have : IsCoprime (2 : ℤ) 3 := by
      rw [Int.isCoprime_iff_gcd_eq_one]; decide
    have := this.mul_dvd h2 h3
    simpa using this
  have c30 : (30 : ℤ) ∣ n^29 - n := by
    have : IsCoprime (6 : ℤ) 5 := by
      rw [Int.isCoprime_iff_gcd_eq_one]; decide
    have := this.mul_dvd c615 h5
    norm_num at this
    exact this
  have c870 : (870 : ℤ) ∣ n^29 - n := by
    have : IsCoprime (30 : ℤ) 29 := by
      rw [Int.isCoprime_iff_gcd_eq_one]; decide
    have := this.mul_dvd c30 h29
    norm_num at this
    exact this
  exact c870