import Unsorry.NicomachusSumCubes
import Mathlib.Algebra.BigOperators.Intervals

theorem sum_range_cube_eq_triangular_sq (n : ℕ) : ∑ i ∈ Finset.range (n + 1), i ^ 3 = (n * (n + 1) / 2) ^ 2 := by
  rw [nicomachus_sum_cubes (n + 1), Finset.sum_range_id, Nat.add_sub_cancel,
    Nat.mul_comm (n + 1) n]
