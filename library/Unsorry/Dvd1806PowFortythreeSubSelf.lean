import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_1806_pow_fortythree_sub_self (n : ℤ) : (1806 : ℤ) ∣ n ^ 43 - n := by
  -- 1806 = 2 * 3 * 7 * 43, squarefree
  have h2 : (2 : ℤ) ∣ n ^ 43 - n := by
    have : ((n ^ 43 - n : ℤ) : ZMod 2) = 0 := by
      push_cast
      have : ∀ x : ZMod 2, x ^ 43 - x = 0 := by decide
      simpa using this (n : ZMod 2)
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ 2).mp this
  have h3 : (3 : ℤ) ∣ n ^ 43 - n := by
    have : ((n ^ 43 - n : ℤ) : ZMod 3) = 0 := by
      push_cast
      have : ∀ x : ZMod 3, x ^ 43 - x = 0 := by decide
      simpa using this (n : ZMod 3)
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ 3).mp this
  have h7 : (7 : ℤ) ∣ n ^ 43 - n := by
    have : ((n ^ 43 - n : ℤ) : ZMod 7) = 0 := by
      push_cast
      have : ∀ x : ZMod 7, x ^ 43 - x = 0 := by decide
      simpa using this (n : ZMod 7)
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ 7).mp this
  have h43 : (43 : ℤ) ∣ n ^ 43 - n := by
    have : ((n ^ 43 - n : ℤ) : ZMod 43) = 0 := by
      push_cast
      have : ∀ x : ZMod 43, x ^ 43 - x = 0 := by decide
      simpa using this (n : ZMod 43)
    exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ 43).mp this
  -- combine via coprimality
  have c1 : IsCoprime (2 : ℤ) 3 := by decide
  have c2 : IsCoprime (6 : ℤ) 7 := by decide
  have c3 : IsCoprime (42 : ℤ) 43 := by decide
  have h6 : (6 : ℤ) ∣ n ^ 43 - n := by
    have := c1.mul_dvd h2 h3
    norm_num at this ⊢
    exact this
  have h42 : (42 : ℤ) ∣ n ^ 43 - n := by
    have := c2.mul_dvd h6 h7
    norm_num at this ⊢
    exact this
  have h1806 : (1806 : ℤ) ∣ n ^ 43 - n := by
    have := c3.mul_dvd h42 h43
    norm_num at this ⊢
    exact this
  exact h1806