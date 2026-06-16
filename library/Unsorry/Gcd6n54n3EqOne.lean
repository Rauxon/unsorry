import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_6n5_4n3_eq_one (n : ℕ) : Nat.gcd (6 * n + 5) (4 * n + 3) = 1 := by
  have h1 := Nat.gcd_dvd_left (6 * n + 5) (4 * n + 3)
  have h2 := Nat.gcd_dvd_right (6 * n + 5) (4 * n + 3)
  have hA : Nat.gcd (6 * n + 5) (4 * n + 3) ∣ 2 * (6 * n + 5) := h1.mul_left 2
  have hB : Nat.gcd (6 * n + 5) (4 * n + 3) ∣ 3 * (4 * n + 3) := h2.mul_left 3
  have key : 2 * (6 * n + 5) = 3 * (4 * n + 3) + 1 := by omega
  rw [key] at hA
  exact Nat.dvd_one.mp ((Nat.dvd_add_right hB).mp hA)
