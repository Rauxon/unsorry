import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_twon_n5_dvd_ten (n : ℕ) : Nat.gcd (2 * n) (n + 5) ∣ 10 := by
  have h1 := Nat.gcd_dvd_left (2 * n) (n + 5)
  have h2 := Nat.gcd_dvd_right (2 * n) (n + 5)
  have hA : Nat.gcd (2 * n) (n + 5) ∣ 2 * (n + 5) := h2.mul_left 2
  have hB : Nat.gcd (2 * n) (n + 5) ∣ 1 * (2 * n) := h1.mul_left 1
  have key : 2 * (n + 5) = 1 * (2 * n) + 10 := by omega
  rw [key] at hA
  exact ((Nat.dvd_add_right hB).mp hA).trans (by norm_num)
