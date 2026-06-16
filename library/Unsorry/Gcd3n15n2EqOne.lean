import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_3n1_5n2_eq_one (n : ℕ) : Nat.gcd (3 * n + 1) (5 * n + 2) = 1 := by
  have h1 := Nat.gcd_dvd_left (3 * n + 1) (5 * n + 2)
  have h2 := Nat.gcd_dvd_right (3 * n + 1) (5 * n + 2)
  have hA : Nat.gcd (3 * n + 1) (5 * n + 2) ∣ 3 * (5 * n + 2) := h2.mul_left 3
  have hB : Nat.gcd (3 * n + 1) (5 * n + 2) ∣ 5 * (3 * n + 1) := h1.mul_left 5
  have key : 3 * (5 * n + 2) = 5 * (3 * n + 1) + 1 := by omega
  rw [key] at hA
  exact Nat.dvd_one.mp ((Nat.dvd_add_right hB).mp hA)
