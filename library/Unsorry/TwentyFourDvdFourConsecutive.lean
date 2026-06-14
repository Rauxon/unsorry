import Mathlib.Data.Int.ModEq
import Mathlib.Data.ZMod.Basic

theorem twenty_four_dvd_four_consecutive (n : ℤ) : (24 : ℤ) ∣ n * (n + 1) * (n + 2) * (n + 3) := by
  have h : ((n * (n + 1) * (n + 2) * (n + 3) : ℤ) : ZMod 24) = 0 := by
    have h1 : ((n * (n + 1) * (n + 2) * (n + 3) : ℤ) : ZMod 24) = (n : ZMod 24) * ((n : ZMod 24) + 1) * ((n : ZMod 24) + 2) * ((n : ZMod 24) + 3) := by push_cast; rfl
    rw [h1]
    generalize (n : ZMod 24) = m
    have h2 : ∀ m : ZMod 24, m * (m + 1) * (m + 2) * (m + 3) = 0 := by decide
    exact h2 m
  exact (ZMod.intCast_zmod_eq_zero_iff_dvd _ _).mp h
