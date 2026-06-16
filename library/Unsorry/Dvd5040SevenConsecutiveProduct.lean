import Mathlib

set_option maxRecDepth 100000 in
theorem dvd_5040_seven_consecutive_product (n : ℤ) : (5040 : ℤ) ∣ n * (n ^ 2 - 1) * (n ^ 2 - 4) * (n ^ 2 - 9) := by
  have key : ∀ (k : ℕ), ((n : ZMod k) * ((n : ZMod k) ^ 2 - 1) * ((n : ZMod k) ^ 2 - 4) * ((n : ZMod k) ^ 2 - 9) = 0) → (k : ℤ) ∣ n * (n ^ 2 - 1) * (n ^ 2 - 4) * (n ^ 2 - 9) := by
    intro k hk
    rw [← ZMod.intCast_zmod_eq_zero_iff_dvd]
    push_cast
    exact hk
  have h16 : (16 : ℤ) ∣ n * (n ^ 2 - 1) * (n ^ 2 - 4) * (n ^ 2 - 9) := by
    have := key 16 (by generalize (n : ZMod 16) = m; revert m; decide)
    norm_num at this; exact this
  have h9 : (9 : ℤ) ∣ n * (n ^ 2 - 1) * (n ^ 2 - 4) * (n ^ 2 - 9) := by
    have := key 9 (by generalize (n : ZMod 9) = m; revert m; decide)
    norm_num at this; exact this
  have h5 : (5 : ℤ) ∣ n * (n ^ 2 - 1) * (n ^ 2 - 4) * (n ^ 2 - 9) := by
    have := key 5 (by generalize (n : ZMod 5) = m; revert m; decide)
    norm_num at this; exact this
  have h7 : (7 : ℤ) ∣ n * (n ^ 2 - 1) * (n ^ 2 - 4) * (n ^ 2 - 9) := by
    have := key 7 (by generalize (n : ZMod 7) = m; revert m; decide)
    norm_num at this; exact this
  have heq : (5040 : ℤ) = 16 * 9 * 5 * 7 := by norm_num
  rw [heq]
  have c1 : IsCoprime (16 : ℤ) 9 := by
    rw [Int.isCoprime_iff_gcd_eq_one]; decide
  have c2 : IsCoprime (16 * 9 : ℤ) 5 := by
    rw [Int.isCoprime_iff_gcd_eq_one]; decide
  have c3 : IsCoprime (16 * 9 * 5 : ℤ) 7 := by
    rw [Int.isCoprime_iff_gcd_eq_one]; decide
  exact (c3.mul_dvd ((c2.mul_dvd (c1.mul_dvd h16 h9)) h5)) h7