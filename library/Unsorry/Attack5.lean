import Mathlib.Algebra.Group.Basic

/-!
# Attack 5 — `native_decide` (compiler-trust) smuggled into the verified library

RED-TEAM PROBE (authorized). This module attempts to land a theorem in
`UnsorryLibrary` (the zero-sorry, kernel-verified package) whose proof is
discharged by `native_decide`. `native_decide` evaluates the decision
procedure with *compiled native code* and trusts the result — it does NOT
produce a kernel-checkable proof term. Instead it introduces a per-declaration
trust axiom (`<decl>._native.native_decide.ax_…`), bypassing the kernel.

Two evasions are stacked here to probe each Gate A layer independently:

1. The tactic is hidden behind a macro alias (`crunch`) so the literal token
   `native_decide` does not appear on the *use* site — a probe of the textual
   lint (which greps the library diff for `native_decide`).

2. The statement is a large concrete arithmetic claim that a contributor might
   plausibly reach for `native_decide` to discharge "because `decide` is too
   slow". This is the exact ergonomic temptation the gate must resist.

If Gate A is sound, the axiom audit must report the
`._native.native_decide.ax_…` axiom (not in the whitelist
`{propext, Classical.choice, Quot.sound}`) as a VIOLATION and fail the gate.
-/

/-- Alias so the literal `native_decide` token is confined to this one macro,
not the theorem's proof site (textual-lint evasion probe). -/
macro "crunch" : tactic => `(tactic| native_decide)

/-- A concrete arithmetic identity discharged by compiled native evaluation
rather than by the kernel. Trusts the compiler. -/
theorem big_pow_mod_zero : (2 ^ 20) % 1000 = 576 := by
  crunch
