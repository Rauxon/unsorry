import Mathlib

/-- The square of any integer is congruent to `0` or `1` modulo `3`. -/
theorem int_sq_mod_three_eq_zero_or_one (a : ℤ) :
    a ^ 2 % 3 = 0 ∨ a ^ 2 % 3 = 1 := by
  have h : a ^ 2 % 3 = (a % 3) * (a % 3) % 3 := by
    rw [pow_two, Int.mul_emod]
  have h0 : 0 ≤ a % 3 := Int.emod_nonneg a (by norm_num)
  have h3 : a % 3 < 3 := Int.emod_lt_of_pos a (by norm_num)
  rw [h]
  interval_cases (a % 3) <;> decide
