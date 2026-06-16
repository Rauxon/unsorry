import Mathlib

theorem dvd_2730_pow_thirteen_sub_self (n : ℤ) : (2730 : ℤ) ∣ n ^ 13 - n := by
  have key : ∀ p : ℕ, (∀ x : ZMod p, x ^ 13 - x = 0) → (p : ℤ) ∣ n ^ 13 - n := by
    intro p hp
    rw [← ZMod.intCast_zmod_eq_zero_iff_dvd]
    push_cast
    exact hp n
  have h2 : (2 : ℤ) ∣ n ^ 13 - n := key 2 (by decide)
  have h3 : (3 : ℤ) ∣ n ^ 13 - n := key 3 (by decide)
  have h5 : (5 : ℤ) ∣ n ^ 13 - n := key 5 (by decide)
  have h7 : (7 : ℤ) ∣ n ^ 13 - n := key 7 (by decide)
  have h13 : (13 : ℤ) ∣ n ^ 13 - n := key 13 (by decide)
  -- 2730 = 2 * 3 * 5 * 7 * 13
  have e1 : (6 : ℤ) ∣ n ^ 13 - n := by
    exact (IsCoprime.mul_dvd (by decide) h2 h3)
  have e2 : (30 : ℤ) ∣ n ^ 13 - n := by
    exact (IsCoprime.mul_dvd (by decide) e1 h5)
  have e3 : (210 : ℤ) ∣ n ^ 13 - n := by
    exact (IsCoprime.mul_dvd (by decide) e2 h7)
  have e4 : (2730 : ℤ) ∣ n ^ 13 - n := by
    exact (IsCoprime.mul_dvd (by decide) e3 h13)
  exact e4