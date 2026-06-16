import Mathlib.Data.ZMod.Basic

/-- The product of five consecutive integers is divisible by `120 = 5!`.

The proof checks that the product vanishes for every residue class modulo `120`
(a finite check in `ZMod 120`) and then lifts the result back to `ℤ`. -/
theorem one_hundred_twenty_dvd_five_consecutive (n : ℤ) :
    (120 : ℤ) ∣ n * (n + 1) * (n + 2) * (n + 3) * (n + 4) := by
  have key : ∀ m : ZMod 120, m * (m + 1) * (m + 2) * (m + 3) * (m + 4) = 0 := by
    set_option maxRecDepth 4000 in decide
  have h : ((n * (n + 1) * (n + 2) * (n + 3) * (n + 4) : ℤ) : ZMod 120) = 0 := by
    push_cast
    exact key (n : ZMod 120)
  rwa [ZMod.intCast_zmod_eq_zero_iff_dvd] at h
