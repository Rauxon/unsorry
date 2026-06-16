import Mathlib

theorem sum_decagonal_numbers_closed_form (n : ℕ) :
    6 * ∑ k ∈ Finset.Icc 1 n, ((k : ℤ) * (4 * k - 3)) = n * (n + 1) * (8 * n - 5) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega : 1 ≤ m + 1)]
    push_cast at ih ⊢
    ring_nf
    ring_nf at ih
    nlinarith [ih]
