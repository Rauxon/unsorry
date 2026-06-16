import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_2n1_2n5_dvd_four (n : ℕ) : Nat.gcd (2 * n + 1) (2 * n + 5) ∣ 4 := by
  have h1 := Nat.gcd_dvd_left (2 * n + 1) (2 * n + 5)
  have h2 := Nat.gcd_dvd_right (2 * n + 1) (2 * n + 5)
  have hA : Nat.gcd (2 * n + 1) (2 * n + 5) ∣ 1 * (2 * n + 5) := h2.mul_left 1
  have hB : Nat.gcd (2 * n + 1) (2 * n + 5) ∣ 1 * (2 * n + 1) := h1.mul_left 1
  have key : 1 * (2 * n + 5) = 1 * (2 * n + 1) + 4 := by omega
  rw [key] at hA
  exact ((Nat.dvd_add_right hB).mp hA).trans (by norm_num)
