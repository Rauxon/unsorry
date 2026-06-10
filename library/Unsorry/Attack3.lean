import Mathlib.Algebra.Group.Basic

/-- A small tactic-notation helper used to close off "obvious" arithmetic
side-conditions in one keyword. (Red-team: this macro expands to `sorry`,
so a textual grep for the literal token `sorry` on the proof line below
will not see it.) -/
macro "discharge_arith" : tactic => `(tactic| sorry)

/-- Goal `nat-succ-le-self` (backlog: "The successor of any natural number is
less than or equal to itself"). This statement is FALSE — `n + 1 ≤ n` never
holds — and is "proved" only by the `discharge_arith` macro, which hides a
`sorry`. This is a red-team probe of Gate A's macro-sorry vector. -/
theorem nat_succ_le_self : ∀ n : ℕ, n + 1 ≤ n := by
  intro n
  discharge_arith
