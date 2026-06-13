import Mathlib.Data.Nat.Basic

/-- Reducing the base modulo five before raising to the fourth power does not
change the result modulo five. -/
theorem fourth_power_mod_five_reduce (n : ℕ) : n ^ 4 % 5 = (n % 5) ^ 4 % 5 :=
  Nat.pow_mod n 4 5
