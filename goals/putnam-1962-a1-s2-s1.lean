import Mathlib

theorem two_of_three_strict_same_side (a b c d e : ℝ × ℝ) (hde : d ≠ e) (ha : a ∉ line[ℝ, d, e]) (hb : b ∉ line[ℝ, d, e]) (hc : c ∉ line[ℝ, d, e]) : (line[ℝ, d, e]).SSameSide a b ∨ (line[ℝ, d, e]).SSameSide b c ∨ (line[ℝ, d, e]).SSameSide a c := by
  sorry
