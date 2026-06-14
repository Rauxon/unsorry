import Mathlib.Tactic.Ring

theorem eight_dvd_consecutive_odd_sq_diff (n : Int) : (8 : Int) ∣ (2 * n + 3) ^ 2 - (2 * n + 1) ^ 2 := by
  ring_nf
  norm_num