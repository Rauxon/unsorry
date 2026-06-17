import Mathlib

/-- The finite sum `∑ 1/((5k+2)(5k+7))` over `k ∈ {0, …, n-1}` telescopes to
`n / (2 (5n + 2))`. Each term splits as a difference of consecutive reciprocals,
so the partial sums collapse; we prove it by induction on `n`. -/
theorem sum_range_recip_five_step_product (n : ℕ) : ∑ k ∈ Finset.range n, (1 : ℚ) / ((5 * (k : ℚ) + 2) * (5 * (k : ℚ) + 7)) = (n : ℚ) / (2 * (5 * (n : ℚ) + 2)) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    have h2 : (5 * (n : ℚ) + 2) ≠ 0 := by positivity
    have h7 : (5 * (n : ℚ) + 7) ≠ 0 := by positivity
    push_cast
    field_simp
    ring
