import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_nsq1_nsq3_dvd_two (n : ℕ) : Nat.gcd (n ^ 2 + 1) (n ^ 2 + 3) ∣ 2 := by
  have h1 := Nat.gcd_dvd_left (n ^ 2 + 1) (n ^ 2 + 3)
  have h2 := Nat.gcd_dvd_right (n ^ 2 + 1) (n ^ 2 + 3)
  have hA : Nat.gcd (n ^ 2 + 1) (n ^ 2 + 3) ∣ 1 * (n ^ 2 + 3) := h2.mul_left 1
  have hB : Nat.gcd (n ^ 2 + 1) (n ^ 2 + 3) ∣ 1 * (n ^ 2 + 1) := h1.mul_left 1
  have key : 1 * (n ^ 2 + 3) = 1 * (n ^ 2 + 1) + 2 := by omega
  rw [key] at hA
  exact ((Nat.dvd_add_right hB).mp hA).trans (by norm_num)
