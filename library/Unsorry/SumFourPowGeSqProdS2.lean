import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Ring

theorem cyclic_half_sum_fourth_eq_sum_fourth (a b c : ℝ) :
    (a^4 + b^4) / 2 + (b^4 + c^4) / 2 + (c^4 + a^4) / 2 = a^4 + b^4 + c^4 := by
  ring_nf
