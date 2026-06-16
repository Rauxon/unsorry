import Mathlib

set_option maxRecDepth 8000 in
theorem three_fourth_powers_zmod_sixteen_mem (a b c : ℤ) :
    ((a^4 + b^4 + c^4 : ℤ) : ZMod 16) ∈ ({0, 1, 2, 3} : Set (ZMod 16)) := by
  have key : ∀ x : ZMod 16, (x^4 = 0 ∨ x^4 = 1) := by decide
  push_cast
  rcases key (a : ZMod 16) with ha | ha <;>
    rcases key (b : ZMod 16) with hb | hb <;>
      rcases key (c : ZMod 16) with hc | hc <;>
        simp only [ha, hb, hc] <;>
        decide