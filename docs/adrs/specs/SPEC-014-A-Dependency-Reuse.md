# SPEC-014-A: Dependency Surfacing for Prove Cycles

Implements: [ADR-014](../ADR-014-Dependency-Reuse.md) · Status: Living · Updated: 2026-06-11

## Helper

`py_helper proved-deps <goal.aisp> <goals-dir> <library-dir> <decompositions-dir>` prints, one per line, `Unsorry.<Module>\t<theorem-name>\t<statement>` for every **proved** dependency of the goal:

- the goal record's `deps≜⟨…⟩` entries, plus
- the sub ids of any decomposition record `decompositions/<goal>.*.aisp` (a recomposing parent reuses its own subs);
- "proved" = has a `library/index` entry (`goal≜` → `name≜`, the authoritative marker);
- the declaring module is located by a `^theorem <name>\b` scan over `library/Unsorry/*.lean` (grandfathered lemmas live in `Basic.lean`, so the module is not always `camel(goal)`);
- the statement comes from `goals/<dep>.lean` when present (display context);
- unproved deps print nothing — ADR-010's gap term routes them first.

## Prompt wiring

`run_proof` calls the helper once per goal (against the PR worktree) and, when non-empty, appends a `PROVED DEPENDENCIES (ADR-014)` section to the prove prompt: one `- import Unsorry.<Module>` line per dep with its statement, and an explicit amendment that the import-tightness rule allows these `Unsorry.*` imports. Advisory only: the gates judge the resulting module identically whether or not the prover uses them.

## Acceptance criteria

`test_proved_deps_surfacing` (agent.sh self-test, hermetic):
1. a declared proved dep surfaces with module, name, statement;
2. an unproved declared dep is silent;
3. a decomposition sub (proved, decomposition record naming the goal as parent) surfaces;
4. output format is exactly tab-separated `Unsorry.<Module>\t<name>\t<stmt>`.

Run-level (thread B exit): a parent merges whose proof file imports a listed `Unsorry.*` module and uses the lemma — recorded in `phase3-run-002`.
