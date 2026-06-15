import Mathlib.Data.Int.ModEq
import Mathlib.Tactic

lemma zmod_eq_iff_dvd (p : ℕ) (a b : ℤ) : (a : ZMod p) = b ↔ (p : ℤ) ∣ a - b := by
  constructor
  · intro h
    have : (p : ℤ) ∣ b - a := (ZMod.intCast_eq_intCast_iff_dvd_sub a b p).mp h
    exact dvd_sub_comm.mp this
  · intro h
    have : (p : ℤ) ∣ b - a := dvd_sub_comm.mpr h
    exact (ZMod.intCast_eq_intCast_iff_dvd_sub a b p).mpr this

lemma dvd_19 (n : ℤ) : (19 : ℤ) ∣ n ^ 19 - n := by
  have : Fact (Nat.Prime 19) := ⟨by norm_num⟩
  apply (zmod_eq_iff_dvd 19 _ _).mp
  push_cast
  exact ZMod.pow_card (n : ZMod 19)

lemma dvd_7 (n : ℤ) : (7 : ℤ) ∣ n ^ 19 - n := by
  have : Fact (Nat.Prime 7) := ⟨by norm_num⟩
  apply (zmod_eq_iff_dvd 7 _ _).mp
  push_cast
  have h := ZMod.pow_card (n : ZMod 7)
  have h2 : (n : ZMod 7) ^ 19 = ((n : ZMod 7) ^ 7) ^ 2 * (n : ZMod 7) ^ 5 := by ring
  rw [h2, h]
  have h3 : (n : ZMod 7) ^ 2 * (n : ZMod 7) ^ 5 = (n : ZMod 7) ^ 7 := by ring
  rw [h3, h]

lemma dvd_3 (n : ℤ) : (3 : ℤ) ∣ n ^ 19 - n := by
  have : Fact (Nat.Prime 3) := ⟨by norm_num⟩
  apply (zmod_eq_iff_dvd 3 _ _).mp
  push_cast
  have h := ZMod.pow_card (n : ZMod 3)
  have h2 : (n : ZMod 3) ^ 19 = ((n : ZMod 3) ^ 3) ^ 6 * (n : ZMod 3) := by ring
  rw [h2, h]
  have h3 : (n : ZMod 3) ^ 6 * (n : ZMod 3) = ((n : ZMod 3) ^ 3) ^ 2 * (n : ZMod 3) := by ring
  rw [h3, h]
  have h4 : (n : ZMod 3) ^ 2 * (n : ZMod 3) = (n : ZMod 3) ^ 3 := by ring
  rw [h4, h]

theorem dvd_399_pow_nineteen_sub_self (n : ℤ) : (399 : ℤ) ∣ n ^ 19 - n := by
  have h3 : 3 ∣ n ^ 19 - n := dvd_3 n
  have h7 : 7 ∣ n ^ 19 - n := dvd_7 n
  have h19 : 19 ∣ n ^ 19 - n := dvd_19 n
  have c1 : IsCoprime (3 : ℤ) 7 := by norm_num
  have c2 : IsCoprime (21 : ℤ) 19 := by norm_num
  have h21 : 21 ∣ n ^ 19 - n := c1.mul_dvd h3 h7
  have h399 : 399 ∣ n ^ 19 - n := c2.mul_dvd h21 h19
  exact h399
