import Unsorry.NesbittInequalityS1
import Unsorry.NesbittInequalityS2
import Unsorry.NesbittInequalityS3
import Unsorry.NesbittInequalityS4

/--
Nesbitt's inequality: for positive reals `a`, `b`, `c`,
`3 / 2 ≤ a / (b + c) + b / (c + a) + c / (a + b)`.

The proof chains the previously verified pieces. The Titu (Cauchy–Schwarz in
Engel form) lower bound gives
`(a + b + c) ^ 2 / (2 * (a * b + b * c + c * a)) ≤ a / (b + c) + b / (c + a) + c / (a + b)`,
and the symmetric bound `3 * (a * b + b * c + c * a) ≤ (a + b + c) ^ 2`
together with positivity of `a * b + b * c + c * a` shows the left quantity is at
least `3 / 2`. Transitivity closes the goal.
-/
theorem nesbitt_inequality (a b c : ℝ) (ha : 0 < a) (hb : 0 < b) (hc : 0 < c) : 3 / 2 ≤ a / (b + c) + b / (c + a) + c / (a + b) := by
  have hpos : 0 < a * b + b * c + c * a := positive_pairwise_sum a b c ha hb hc
  have hineq : 3 * (a * b + b * c + c * a) ≤ (a + b + c) ^ 2 :=
    three_pairwise_le_sum_square a b c
  have hlower : 3 / 2 ≤ (a + b + c) ^ 2 / (2 * (a * b + b * c + c * a)) :=
    symmetric_bound_implies_three_halves a b c hpos hineq
  have htitu : (a + b + c) ^ 2 / (2 * (a * b + b * c + c * a)) ≤
      a / (b + c) + b / (c + a) + c / (a + b) :=
    nesbitt_titu_lower_bound a b c ha hb hc
  linarith
