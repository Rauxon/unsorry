import Lean.Linter.UnusedVariables
import Mathlib.Data.Nat.Basic

/-!
# `fourth_power_mod_five` (goal `fourth-power-mod-five`)

A natural number `n` that is not a multiple of `5` satisfies `n ^ 4 ≡ 1 (mod 5)`.

The fourth power commutes with the residue (`Nat.pow_mod`), so it suffices to
know `(n % 5) ^ 4 % 5 = 1`. The residue `n % 5` is below `5` and, by hypothesis,
nonzero, hence one of `1, 2, 3, 4`; each of `1 ^ 4, 2 ^ 4, 3 ^ 4, 4 ^ 4` is
congruent to `1` modulo `5`, which closes every branch by computation.
-/

theorem fourth_power_mod_five (n : ℕ) (h : n % 5 ≠ 0) : n ^ 4 % 5 = 1 := by
  have hcases : n % 5 = 1 ∨ n % 5 = 2 ∨ n % 5 = 3 ∨ n % 5 = 4 := by omega
  rw [Nat.pow_mod]
  rcases hcases with h' | h' | h' | h' <;> rw [h']

/-- The ADR-011 binding obligation that Gate A regenerates for this goal states
its type as `∀ (n : ℕ) (h : n % 5 ≠ 0), n ^ 4 % 5 = 1`, copying the goal's
binder names verbatim. `h` does not occur in the conclusion, so the
unused-variables linter warns on it and the `--wfail` bar fails — in a
generated file this module cannot edit. Core Lean already exempts unused
binders in the arrow spelling `(h : P) → Q` of the same type (its builtin
`depArrow` ignore function), because a binder name there is signature
documentation; this extends that exemption to the `∀ (h : P), Q` spelling,
exactly as the merged `Unsorry.PlatonicSchlafliCoreS1S2` does for its goal.
Lint-scope only: it has no effect on elaboration, the kernel check, or the
audit gate. -/
@[unused_variables_ignore_fn]
def Unsorry.FourthPowerModFive.ignoreForallTypeBinders :
    Lean.Linter.IgnoreFunction := fun _ stack _ =>
  stack.matches [`null, ``Lean.Parser.Term.explicitBinder, `null,
    ``Lean.Parser.Term.«forall»]
