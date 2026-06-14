# Proof Authoring Repo Map

## Load Order

Use this order when starting a proof task:

1. `goals/<id>.aisp`: queue status, phase, difficulty, deps, source, artifact pointer, SHA.
2. `goals/<id>.lean`: exact statement. Treat existing statements as immutable.
3. `backlog/<id>.md`: natural-language source, absence evidence, reference URL or citation.
4. `library/Unsorry/*.lean`: proved reusable library theorems.
5. `library/index/*.aisp`: content-addressed metadata for proved statements.
6. `proof-runs/*.aisp`: terminal coordinated run facts, if the task is about telemetry.

## Authority Boundaries

- Lean kernel checks proof correctness.
- Gate A enforces proof admission for `library/`.
- Gate B validates queue and metadata records.
- Generated docs summarize state but are not source of truth.

## Directory Roles

| Path | Role | Proof-authoring rule |
|---|---|---|
| `goals/` | Lean targets plus AISP goal records | Do not weaken existing `*.lean` statements. |
| `library/Unsorry/` | Verified proof library | Must remain zero-sorry and Gate A clean. |
| `library/index/` | Content-addressed records | Keep filename, `sha`, `stmt`, and `goal` consistent. |
| `backlog/` | Source theorem descriptions | Preserve source and absence evidence. |
| `decompositions/` | Failed-goal split records | Use when proof budget is exhausted and subgoals are honest. |
| `proof-runs/` | Terminal coordinated run telemetry | Do not fabricate for local-only attempts. |
| `docs/targets.md` | Generated work board | Regenerate/check after goal/index changes. |
| `docs/leaderboard.md` | Generated contributor stats | Regenerate/check after index/proof-run changes. |

## Useful Searches

```bash
rg -n "<goal-id>" goals library library/index backlog proof-runs docs
rg -n "theorem <name>|lemma <name>|def <name>" library/Unsorry goals
rg -n "status≜open|status≜translated|status≜proved" goals
rg -n "goal≜<goal-id>|stmt≜|sha≜" library/index
```

## Build Targets

`UnsorryLibrary` is the verified library and should build with `--wfail`. `UnsorryGoals` contains open goals where `sorry` is expected. `lake build` builds both default targets.
