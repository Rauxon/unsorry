# Claims And Telemetry

## Claims

Claims live on the `claims` branch, not on `main`. The filename pattern is:

```text
claims/<goal-id>.<agent-id>.aisp
```

First push wins. If the push is rejected, fetch/rebase the claims branch and pick another goal if a competing live claim appeared.

Claims carry TTLs. Expired claims are reaped, so do not infer ownership from stale local files.

## Proof Runs

`proof-runs/` is an append-only fact table for terminal coordinated proof runs:

- `proved`: proof passed local verification and the proof PR carries the matching index entry.
- `decomposed`: proof budget was exhausted and an accepted decomposition PR carries the run.
- `failed`: proof budget was exhausted and an affinity-demotion PR carries the run.

Infrastructure failures and local-only smoke runs are excluded.

## Attribution

Telemetry may record solver, agent, provider, model, effort, attempts, and elapsed time. `UNSORRY_SOLVER` can override the credited GitHub handle. Do not reconstruct historical attribution by guessing from git history.

## Analytics

After `library/index/` or `proof-runs/` changes:

```bash
python3 -m tools.gate_b validate .
python3 -m tools.leaderboard --check .
python3 -m tools.visualiser --check .
```

Regenerate only when source changes are intentional:

```bash
python3 -m tools.leaderboard --write .
python3 -m tools.visualiser --write .
```
