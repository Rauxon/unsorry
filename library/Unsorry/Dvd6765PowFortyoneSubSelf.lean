import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_6765_pow_fortyone_sub_self (n : ℤ) : (6765 : ℤ) ∣ n ^ 41 - n := by
  have key : ∀ p : ℕ, Nat.Prime p → (∀ x : ZMod p, x ^ 41 = x) → (p : ℤ) ∣ n ^ 41 - n := by
    intro p hp hall
    haveI : Fact (Nat.Prime p) := ⟨hp⟩
    have : ((n ^ 41 - n : ℤ) : ZMod p) = 0 := by
      push_cast
      rw [hall]
      ring
    exact_mod_cast (ZMod.intCast_zmod_eq_zero_iff_dvd _ p).mp this
  have h3 : (3 : ℤ) ∣ n ^ 41 - n := key 3 (by norm_num) (by decide)
  have h5 : (5 : ℤ) ∣ n ^ 41 - n := key 5 (by norm_num) (by decide)
  have h11 : (11 : ℤ) ∣ n ^ 41 - n := key 11 (by norm_num) (by decide)
  have h41 : (41 : ℤ) ∣ n ^ 41 - n := key 41 (by norm_num) (by decide)
  have c35 : IsCoprime (3 : ℤ) 5 := by
    rw [Int.isCoprime_iff_gcd_eq_one]; decide
  have c155 : IsCoprime (3 * 5 : ℤ) 11 := by
    rw [Int.isCoprime_iff_gcd_eq_one]; decide
  have c16541 : IsCoprime (3 * 5 * 11 : ℤ) 41 := by
    rw [Int.isCoprime_iff_gcd_eq_one]; decide
  have d15 : (3 * 5 : ℤ) ∣ n ^ 41 - n := c35.mul_dvd h3 h5
  have d165 : (3 * 5 * 11 : ℤ) ∣ n ^ 41 - n := c155.mul_dvd d15 h11
  have d6765 : (3 * 5 * 11 * 41 : ℤ) ∣ n ^ 41 - n := c16541.mul_dvd d165 h41
  have : (3 * 5 * 11 * 41 : ℤ) = 6765 := by norm_num
  rwa [this] at d6765