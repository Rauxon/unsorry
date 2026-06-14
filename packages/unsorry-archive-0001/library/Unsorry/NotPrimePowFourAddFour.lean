import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Tactic.Ring

theorem not_prime_pow_four_add_four {n : ℕ} (hn : 1 < n) : ¬ Nat.Prime (n ^ 4 + 4) := by
  obtain ⟨m, rfl⟩ : ∃ m, n = m + 2 := ⟨n - 2, by omega⟩
  have h : (m + 2) ^ 4 + 4 = (m ^ 2 + 2 * m + 2) * (m ^ 2 + 6 * m + 10) := by
    ring
  rw [h]
  exact Nat.not_prime_mul (by omega) (by omega)
