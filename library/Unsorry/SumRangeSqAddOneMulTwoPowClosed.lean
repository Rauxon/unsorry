import Mathlib

/-!
# A closed form for `∑ k < n, (k² + 1) · 2ᵏ`

This module establishes that the partial sums of `(k² + 1) · 2ᵏ` over `Finset.range n`
admit the closed form `(n² - 4n + 7) · 2ⁿ - 7`, by induction on `n`.
-/

theorem sum_range_sq_add_one_mul_two_pow_closed (n : ℕ) :
    ∑ k ∈ Finset.range n, ((k : ℤ) ^ 2 + 1) * 2 ^ k
      = ((n : ℤ) ^ 2 - 4 * n + 7) * 2 ^ n - 7 := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    ring
