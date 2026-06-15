import Mathlib.Tactic.Ring
import Mathlib.Algebra.Ring.Int.Parity

theorem consecutive_cubes_diff_odd (n : ℤ) : Odd ((n + 1) ^ 3 - n ^ 3) := by
  rcases Int.even_or_odd' n with ⟨k, hk | hk⟩
  · use 6 * k ^ 2 + 3 * k
    rw [hk]
    ring
  · use 6 * k ^ 2 + 9 * k + 3
    rw [hk]
    ring
