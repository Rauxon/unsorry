import Mathlib

theorem coprime_divisor_product_unique (m n d : ℕ) (h : Nat.Coprime m n) (hd : d ∈ Nat.divisors (m * n)) : ∃! p : ℕ × ℕ, p.1 ∈ Nat.divisors m ∧ p.2 ∈ Nat.divisors n ∧ p.1 * p.2 = d := by
  sorry
