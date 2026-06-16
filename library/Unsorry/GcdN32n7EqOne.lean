import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_n3_2n7_eq_one (n : ℕ) : Nat.gcd (n + 3) (2 * n + 7) = 1 := by
  have h1 := Nat.gcd_dvd_left (n + 3) (2 * n + 7)
  have h2 := Nat.gcd_dvd_right (n + 3) (2 * n + 7)
  have hA : Nat.gcd (n + 3) (2 * n + 7) ∣ 1 * (2 * n + 7) := h2.mul_left 1
  have hB : Nat.gcd (n + 3) (2 * n + 7) ∣ 2 * (n + 3) := h1.mul_left 2
  have key : 1 * (2 * n + 7) = 2 * (n + 3) + 1 := by omega
  rw [key] at hA
  exact Nat.dvd_one.mp ((Nat.dvd_add_right hB).mp hA)
