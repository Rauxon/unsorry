import Mathlib

theorem one_hundred_twenty_dvd_five_consecutive (n : ℤ) :
    (120 : ℤ) ∣ n * (n + 1) * (n + 2) * (n + 3) * (n + 4) := by
  have : ((120 : ℕ) : ℤ) ∣ n * (n + 1) * (n + 2) * (n + 3) * (n + 4) → (120 : ℤ) ∣ n * (n + 1) * (n + 2) * (n + 3) * (n + 4) := by
    norm_num
  apply this
  rw [← ZMod.intCast_zmod_eq_zero_iff_dvd]
  push_cast
  have key : ∀ m : ZMod 120, m * (m + 1) * (m + 2) * (m + 3) * (m + 4) = 0 := by
    decide +kernel
  exact key (n : ZMod 120)