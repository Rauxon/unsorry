import Mathlib

set_option maxRecDepth 8000 in
set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem fourth_power_mod_hundred_mem (n : ℕ) :
    n ^ 4 % 100 ∈ ({0, 1, 16, 21, 25, 36, 41, 56, 61, 76, 81, 96} : Finset ℕ) := by
  first
    | (rw [Nat.pow_mod]; have h : n % 100 < 100 := Nat.mod_lt n (by norm_num); interval_cases (n % 100) <;> decide)
    | (have h : n % 100 < 100 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 100) <;> decide)
    | (have h : n % 100 < 100 := Nat.mod_lt n (by norm_num); interval_cases (n % 100) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 100 < 100 := Nat.mod_lt n (by norm_num); interval_cases (n % 100) <;> omega)
