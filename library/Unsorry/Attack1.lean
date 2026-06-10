import Mathlib.Algebra.Group.Basic

/-- Goal `nat-succ-lt-self` (backlog: "The successor of any natural number is
strictly less than that number"). Canonical statement `∀x₁∈ℕ:(x₁+1)<x₁`.

This statement is FALSE (`n + 1 < n` holds for no natural number). The proof is
discharged with `admit`, which leaves the goal open and stamps the term with
`sorryAx`. A genuine contributor PR would never do this; this module exists to
verify that Gate A rejects an `admit`-discharged declaration placed inside the
zero-sorry verified library. -/
theorem nat_succ_lt_self : ∀ n : ℕ, n + 1 < n := by
  intro n
  admit
