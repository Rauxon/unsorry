import Mathlib
open Finset

theorem sum_range_succ_k_mul_choose_mul_two_pow_closed (n : ℕ) : 3 * ∑ k ∈ Finset.range (n + 1), (k + 1) * n.choose k * 2 ^ k = (2 * n + 3) * 3 ^ n := by
  -- helper 1: ∑ C(n,k)*2^k = 3^n
  have hsum1 : ∀ N : ℕ, ∑ k ∈ Finset.range (N + 1), N.choose k * 2 ^ k = 3 ^ N := by
    intro N
    have := add_pow (2:ℕ) 1 N
    simp only [one_pow, mul_one, Nat.cast_id] at this
    rw [show ((2:ℕ)+1) = 3 from rfl] at this
    rw [this]
    exact Finset.sum_congr rfl (fun k hk => by rw [mul_comm])
  -- helper 2: 3 * ∑ k*C(n,k)*2^k = 2*n*3^n
  have hsum2 : 3 * ∑ k ∈ Finset.range (n + 1), k * n.choose k * 2 ^ k = 2 * n * 3 ^ n := by
    cases n with
    | zero => simp
    | succ m =>
      rw [Finset.sum_range_succ']
      simp only [zero_mul, add_zero]
      have step : ∀ k ∈ Finset.range (m+1), (k + 1) * (m + 1).choose (k + 1) * 2 ^ (k + 1)
          = (m+1) * 2 * (m.choose k * 2 ^ k) := by
        intro k hk
        have h := Nat.add_one_mul_choose_eq m k
        have h2 : (k + 1) * (m + 1).choose (k + 1) = (m+1) * m.choose k := by
          rw [mul_comm, ← h]
        have e : (k + 1) * (m + 1).choose (k + 1) * 2 ^ (k + 1)
            = ((k + 1) * (m + 1).choose (k + 1)) * 2 ^ (k + 1) := by ring
        rw [e, h2, pow_succ]
        ring
      rw [Finset.sum_congr rfl step, ← Finset.mul_sum, hsum1 m]
      ring
  -- split (k+1)*C(n,k)*2^k into k*C(n,k)*2^k + C(n,k)*2^k
  have split : ∑ k ∈ Finset.range (n + 1), (k + 1) * n.choose k * 2 ^ k
      = (∑ k ∈ Finset.range (n + 1), k * n.choose k * 2 ^ k)
        + ∑ k ∈ Finset.range (n + 1), n.choose k * 2 ^ k := by
    rw [← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl (fun k hk => by ring)
  rw [split, Nat.mul_add, hsum2, hsum1 n]
  ring