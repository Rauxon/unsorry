# binder-shape-canary

A **Gate A regression fixture**, not a mathematical target. It carries the
implicit-then-named-hypothesis binder shape (`{n : Nat} (h : 1 < n)`) that
[issue #231](https://github.com/agenticsnz/unsorry/issues/231) showed makes a goal's
regenerated ADR-011 binding obligation trip `linter.unusedVariables` under the Gate A
`--wfail` build — which had made every goal of this shape unprovable regardless of the
proof's correctness.

Because Gate A regenerates and builds this goal's binding on every run, the canary keeps
the fix (`set_option linter.unusedVariables false in` on generated bindings) verified
end-to-end, forever: a regression goes red here, at the gate, not on a contributor's PR.

- **Source:** Gate A regression fixture (issue #231)

> No machine **Absence** check applies — this is not a candidate for mathlib upstreaming,
> and the upstream pipeline (ADR-020) correctly never packets it.
