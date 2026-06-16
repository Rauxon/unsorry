import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_5n2_7n3_eq_one (n : ℕ) : Nat.gcd (5 * n + 2) (7 * n + 3) = 1 := by
  have h1 := Nat.gcd_dvd_left (5 * n + 2) (7 * n + 3)
  have h2 := Nat.gcd_dvd_right (5 * n + 2) (7 * n + 3)
  have hA : Nat.gcd (5 * n + 2) (7 * n + 3) ∣ 5 * (7 * n + 3) := h2.mul_left 5
  have hB : Nat.gcd (5 * n + 2) (7 * n + 3) ∣ 7 * (5 * n + 2) := h1.mul_left 7
  have key : 5 * (7 * n + 3) = 7 * (5 * n + 2) + 1 := by omega
  rw [key] at hA
  exact Nat.dvd_one.mp ((Nat.dvd_add_right hB).mp hA)
