import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_5n3_7n4_eq_one (n : ℕ) : Nat.gcd (5 * n + 3) (7 * n + 4) = 1 := by
  have h1 := Nat.gcd_dvd_left (5 * n + 3) (7 * n + 4)
  have h2 := Nat.gcd_dvd_right (5 * n + 3) (7 * n + 4)
  have hA : Nat.gcd (5 * n + 3) (7 * n + 4) ∣ 7 * (5 * n + 3) := h1.mul_left 7
  have hB : Nat.gcd (5 * n + 3) (7 * n + 4) ∣ 5 * (7 * n + 4) := h2.mul_left 5
  have key : 7 * (5 * n + 3) = 5 * (7 * n + 4) + 1 := by omega
  rw [key] at hA
  exact Nat.dvd_one.mp ((Nat.dvd_add_right hB).mp hA)
