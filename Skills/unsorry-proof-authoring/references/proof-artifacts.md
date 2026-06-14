# Proof Artifact Relationships

## Goal Record

`goals/<id>.aisp` identifies the work item. Key fields:

- `phase`: usually `prove` for proof-authoring tasks.
- `status`: `open`, `translated`, `blocked`, `flagged`, or `proved`.
- `difficulty`: integer difficulty band used by the queue.
- `src`: source/backlog path.
- `deps`: other goal ids that should be proved first.
- `lean`: expected Lean goal file.
- `sha`: content address for proved statements.

## Lean Goal

`goals/<id>.lean` contains the canonical theorem statement with `sorry`. It is the statement-binding source. Do not edit an existing goal statement to match an easier library proof.

If a new statement is needed, create a new goal or decomposition path instead of rewriting history.

## Library Proof

Put reusable proved theorems under `library/Unsorry/*.lean`. Follow nearby naming style:

```lean
import Mathlib...

/-- Goal `<goal-id>` ... see `library/index/`. -/
theorem theorem_name : <exact statement> := by
  ...
```

Avoid unnecessary namespace, option, and import changes. If a proof needs helper lemmas, keep them near the theorem unless they are broadly reusable.

## Index Record

`library/index/<sha>.aisp` is metadata about a proved statement. The `sha` should match the filename stem and the content-addressed statement. Use existing records as the authoritative schema example.

Use `assets/library-index-record.template.aisp` only as a starting skeleton. Always compare with a nearby real index record before committing.

## Decomposition

When a parent goal cannot be proved honestly, record a decomposition into subgoals. The decomposition must preserve the parent statement's meaning and create useful child goals, not hide a proof failure.

Use `assets/decomposition-record.template.aisp` as a prompt/checklist, then conform to the current repository schema by comparing with `decompositions/*.aisp`.

## Hash And Statement Checks

The exact hash workflow may be implemented in repository tooling. Before hand-editing hashes, inspect:

```bash
rg -n "sha256|content address|stmt≜|sha≜" tools library/index docs
python3 -m tools.gate_b validate .
```

If a hash or binding check fails, fix the artifact relationship rather than weakening the statement.
