import Mathlib

theorem sum_id_mul_triangular_closed_form (n : ℕ) : 24 * ∑ k ∈ Finset.range n, k * (k * (k + 1) / 2) = (n - 1) * n * (n + 1) * (3 * n - 2) := by
  -- First rewrite the summand to remove the truncated division.
  have hsum : ∀ m : ℕ, 24 * ∑ k ∈ Finset.range m, k * (k * (k + 1) / 2)
      = 12 * ∑ k ∈ Finset.range m, k * (k * (k + 1)) := by
    intro m
    rw [Finset.mul_sum, Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro k _
    have h2 : 2 * (k * (k + 1) / 2) = k * (k + 1) := by
      have : 2 ∣ k * (k + 1) := (Nat.even_mul_succ_self k).two_dvd
      omega
    -- 24 * (k * (k*(k+1)/2)) = 12 * (k * (k*(k+1)))
    have : 2 * (k * (k * (k + 1) / 2)) = k * (k * (k + 1)) := by
      calc 2 * (k * (k * (k + 1) / 2)) = k * (2 * (k * (k + 1) / 2)) := by ring
        _ = k * (k * (k + 1)) := by rw [h2]
    omega
  rw [hsum]
  -- Now prove 12 * ∑ = RHS by induction.
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    -- RHS for m: (m-1)*m*(m+1)*(3m-2); for m+1: m*(m+1)*(m+2)*(3m+1)
    rcases m with _ | k
    · simp
    · -- m = k+1, so m-1 = k, 3m-2 = 3k+1, etc.
      have e1 : (k + 1 - 1) = k := by omega
      have e2 : (3 * (k + 1) - 2) = 3 * k + 1 := by omega
      have e3 : (3 * (k + 1 + 1) - 2) = 3 * k + 4 := by omega
      have e4 : (k + 1 + 1 - 1) = k + 1 := by omega
      rw [e1, e2, e3, e4]
      ring