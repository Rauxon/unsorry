import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_3n2_5n4_dvd_two (n : ℕ) : Nat.gcd (3 * n + 2) (5 * n + 4) ∣ 2 := by
  have h1 := Nat.gcd_dvd_left (3 * n + 2) (5 * n + 4)
  have h2 := Nat.gcd_dvd_right (3 * n + 2) (5 * n + 4)
  have hA : Nat.gcd (3 * n + 2) (5 * n + 4) ∣ 3 * (5 * n + 4) := h2.mul_left 3
  have hB : Nat.gcd (3 * n + 2) (5 * n + 4) ∣ 5 * (3 * n + 2) := h1.mul_left 5
  have key : 3 * (5 * n + 4) = 5 * (3 * n + 2) + 2 := by omega
  rw [key] at hA
  exact ((Nat.dvd_add_right hB).mp hA).trans (by norm_num)
