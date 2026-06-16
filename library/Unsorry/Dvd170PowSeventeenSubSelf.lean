import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_170_pow_seventeen_sub_self (n : ℤ) : (170 : ℤ) ∣ n ^ 17 - n := by
  have key : ∀ p : ℕ, (∀ x : ZMod p, x ^ 17 = x) → (p : ℤ) ∣ n ^ 17 - n := by
    intro p hp
    have := ZMod.intCast_zmod_eq_zero_iff_dvd (n ^ 17 - n) p
    rw [← this]
    push_cast
    rw [hp]
    ring
  have h2 : (2 : ℤ) ∣ n ^ 17 - n := key 2 (by decide)
  have h5 : (5 : ℤ) ∣ n ^ 17 - n := key 5 (by decide)
  have h17 : (17 : ℤ) ∣ n ^ 17 - n := key 17 (by decide)
  have : (170 : ℤ) = 2 * 5 * 17 := by norm_num
  rw [this]
  -- 2, 5, 17 pairwise coprime
  have c25 : IsCoprime (2 : ℤ) 5 := by
    rw [Int.isCoprime_iff_gcd_eq_one]; decide
  have c10_17 : IsCoprime (2 * 5 : ℤ) 17 := by
    rw [Int.isCoprime_iff_gcd_eq_one]; decide
  exact (c10_17.mul_dvd (c25.mul_dvd h2 h5) h17)