import Mathlib

theorem sum_coprime_product_divisors_as_pairs (m n : ℕ) (h : Nat.Coprime m n) : ∑ d ∈ Nat.divisors (m * n), d = ∑ a ∈ Nat.divisors m, ∑ b ∈ Nat.divisors n, a * b := by
  sorry
