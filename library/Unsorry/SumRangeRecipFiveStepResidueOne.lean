import Mathlib

/-- A telescoping sum: the partial sums of `5 / ((5k+1)(5k+6))` collapse to
`1 - 1 / (5n+1)`, since each term equals `1/(5k+1) - 1/(5(k+1)+1)`. -/
theorem sum_range_recip_five_step_residue_one (n : ℕ) : ∑ k ∈ Finset.range n, (5 : ℚ) / ((5 * (k : ℚ) + 1) * (5 * (k : ℚ) + 6)) = 1 - 1 / (5 * (n : ℚ) + 1) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    have h1 : (5 * (n : ℚ) + 1) ≠ 0 := by positivity
    have h2 : (5 * (n : ℚ) + 6) ≠ 0 := by positivity
    push_cast
    field_simp
    ring
