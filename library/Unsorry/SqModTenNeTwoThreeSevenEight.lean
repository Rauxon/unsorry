import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem sq_mod_ten_ne_two_three_seven_eight (n : ℕ) : n ^ 2 % 10 ≠ 2 ∧ n ^ 2 % 10 ≠ 3 ∧ n ^ 2 % 10 ≠ 7 ∧ n ^ 2 % 10 ≠ 8 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 10 < 10 := Nat.mod_lt n (by norm_num); interval_cases (n % 10) <;> decide)
    | (have h : n % 10 < 10 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 10) <;> decide)
    | (have h : n % 10 < 10 := Nat.mod_lt n (by norm_num); interval_cases (n % 10) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 10 < 10 := Nat.mod_lt n (by norm_num); interval_cases (n % 10) <;> omega)
