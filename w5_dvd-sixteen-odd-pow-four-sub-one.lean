import Mathlib

set_option maxRecDepth 8000 in
theorem dvd_sixteen_odd_pow_four_sub_one (n : ℤ) (hn : Odd n) : (16 : ℤ) ∣ n ^ 4 - 1 := by
  obtain ⟨k, rfl⟩ := hn
  ring_nf
  have : (2 * k + 1) ^ 4 - 1 = 16 * (k ^ 4 / 1) := by ring_nf
  sorry
