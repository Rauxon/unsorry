import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_138_pow_twentythree_sub_self (n : ℤ) : (138 : ℤ) ∣ n ^ 23 - n := by
  have key : ∀ (k : ℕ) (hk : 0 < k), (∀ x : ZMod k, x ^ 23 - x = 0) → (k : ℤ) ∣ n ^ 23 - n := by
    intro k hk hx
    have : ((n ^ 23 - n : ℤ) : ZMod k) = 0 := by
      push_cast
      exact hx _
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ k).mp this
  have h2 : (2 : ℤ) ∣ n ^ 23 - n := by
    have := key 2 (by norm_num) (by decide)
    simpa using this
  have h3 : (3 : ℤ) ∣ n ^ 23 - n := by
    have := key 3 (by norm_num) (by decide)
    simpa using this
  have h23 : (23 : ℤ) ∣ n ^ 23 - n := by
    have := key 23 (by norm_num) (by decide)
    simpa using this
  have h6 : (6 : ℤ) ∣ n ^ 23 - n := by
    have : IsCoprime (2 : ℤ) 3 := by
      rw [Int.isCoprime_iff_gcd_eq_one]; decide
    have := this.mul_dvd h2 h3
    norm_num at this ⊢
    exact this
  have hfinal : (138 : ℤ) ∣ n ^ 23 - n := by
    have hco : IsCoprime (6 : ℤ) 23 := by
      rw [Int.isCoprime_iff_gcd_eq_one]; decide
    have := hco.mul_dvd h6 h23
    norm_num at this ⊢
    exact this
  exact hfinal