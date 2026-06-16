import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_903_pow_fortythree_sub_self (n : ℤ) : (903 : ℤ) ∣ n ^ 43 - n := by
  have h : (903 : ℤ) = 3 * 7 * 43 := by norm_num
  rw [h]
  have key : ∀ (m : ℕ) (hm : 0 < m), (∀ x : ZMod m, x ^ 43 = x) → (m : ℤ) ∣ n ^ 43 - n := by
    intro m hm hx
    have : ((n ^ 43 - n : ℤ) : ZMod m) = 0 := by
      push_cast
      rw [hx]
      ring
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ _).mp this
  have h3 : (3 : ℤ) ∣ n ^ 43 - n := key 3 (by norm_num) (by decide)
  have h7 : (7 : ℤ) ∣ n ^ 43 - n := key 7 (by norm_num) (by decide)
  have h43 : (43 : ℤ) ∣ n ^ 43 - n := key 43 (by norm_num) (by decide)
  have h21 : (21 : ℤ) ∣ n ^ 43 - n := by
    have : IsCoprime (3 : ℤ) 7 := by
      rw [Int.isCoprime_iff_gcd_eq_one]; decide
    exact (this.mul_dvd h3 h7)
  have : IsCoprime (21 : ℤ) 43 := by
    rw [Int.isCoprime_iff_gcd_eq_one]; decide
  have := this.mul_dvd h21 h43
  exact this