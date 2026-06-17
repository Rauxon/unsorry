import Mathlib

/-- The signed sum `∑ (n - 2k) * C(n,k)^2` over `k = 0,…,n` vanishes.

The summand is antisymmetric under the reflection `k ↦ n - k`: the binomial
coefficient is invariant (`Nat.choose_symm`) while the linear factor `n - 2k`
flips sign, so pairing each term with its mirror image cancels everything. -/
theorem sum_range_disp_mul_choose_sq_eq_zero (n : ℕ) :
    ∑ k ∈ Finset.range (n + 1), ((n : ℤ) - 2 * k) * (n.choose k : ℤ) ^ 2 = 0 := by
  set f : ℕ → ℤ := fun k => ((n : ℤ) - 2 * k) * (n.choose k : ℤ) ^ 2 with hf
  have hrefl := Finset.sum_range_reflect f (n + 1)
  have hneg : ∀ k ∈ Finset.range (n + 1), f (n + 1 - 1 - k) = - f k := by
    intro k hk
    rw [Finset.mem_range, Nat.lt_succ_iff] at hk
    simp only [hf]
    have e1 : n + 1 - 1 - k = n - k := by omega
    rw [e1, Nat.choose_symm hk, Nat.cast_sub hk]
    ring
  have h0 : ∑ k ∈ Finset.range (n + 1), (f k + f (n + 1 - 1 - k)) = 0 := by
    apply Finset.sum_eq_zero
    intro k hk
    rw [hneg k hk]
    ring
  rw [Finset.sum_add_distrib, hrefl] at h0
  linarith
