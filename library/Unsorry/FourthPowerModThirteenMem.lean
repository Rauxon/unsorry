import Mathlib.Tactic.IntervalCases

/-- For every natural number `n`, the fourth power `n ^ 4` is congruent to one of
`0, 1, 3, 9` modulo `13`. The proof reduces `n` to its residue `n % 13`, of which
there are finitely many, and checks each case by evaluation. -/
theorem fourth_power_mod_thirteen_mem (n : ℕ) :
    n ^ 4 % 13 = 0 ∨ n ^ 4 % 13 = 1 ∨ n ^ 4 % 13 = 3 ∨ n ^ 4 % 13 = 9 := by
  have h : n ^ 4 % 13 = (n % 13) ^ 4 % 13 := by rw [Nat.pow_mod]
  have hlt : n % 13 < 13 := Nat.mod_lt _ (by decide)
  rw [h]
  interval_cases (n % 13) <;> decide
