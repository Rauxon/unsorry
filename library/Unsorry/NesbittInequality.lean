import Unsorry.NesbittInequalityS1
import Unsorry.NesbittInequalityS2
import Unsorry.NesbittInequalityS3
import Unsorry.NesbittInequalityS4

/-!
# Nesbitt's inequality

For positive reals `a`, `b`, `c`,
`3 / 2 ≤ a / (b + c) + b / (c + a) + c / (a + b)`.

The proof chains four kernel-verified pieces already in this library:
* a Titu/Cauchy–Schwarz lower bound rewriting the cyclic sum below the square
  fraction `(a + b + c) ^ 2 / (2 * (a * b + b * c + c * a))`;
* the elementary bound `3 * (a * b + b * c + c * a) ≤ (a + b + c) ^ 2`;
* positivity of the pairwise sum `a * b + b * c + c * a`;
* the step turning those two facts into `3 / 2 ≤ (a + b + c) ^ 2 / …`.

Composing them by transitivity yields the full statement.
-/

theorem nesbitt_inequality (a b c : ℝ) (ha : 0 < a) (hb : 0 < b) (hc : 0 < c) :
    3 / 2 ≤ a / (b + c) + b / (c + a) + c / (a + b) := by
  have hpos : 0 < a * b + b * c + c * a := positive_pairwise_sum a b c ha hb hc
  have hineq : 3 * (a * b + b * c + c * a) ≤ (a + b + c) ^ 2 :=
    three_pairwise_le_sum_square a b c
  have hhalf : 3 / 2 ≤ (a + b + c) ^ 2 / (2 * (a * b + b * c + c * a)) :=
    symmetric_bound_implies_three_halves a b c hpos hineq
  exact hhalf.trans (nesbitt_titu_lower_bound a b c ha hb hc)
