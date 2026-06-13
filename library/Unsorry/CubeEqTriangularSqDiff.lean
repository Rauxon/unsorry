import Mathlib.Algebra.BigOperators.Intervals
import Unsorry.NicomachusSumCubes

theorem cube_eq_triangular_sq_diff (n : ℕ) :
    (∑ i ∈ Finset.range n, i) ^ 2 + n ^ 3 = (∑ i ∈ Finset.range (n + 1), i) ^ 2 := by
  rw [← nicomachus_sum_cubes n, ← nicomachus_sum_cubes (n + 1), Finset.sum_range_succ]
