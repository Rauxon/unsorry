# Generated Artifacts

## Targets Board

Source inputs:

- `goals/*.aisp`
- `library/index/*.aisp`
- `backlog/*.md`
- `docs/upstream/*.md`

Commands:

```bash
python3 -m tools.sourcing.targets_board --check .
python3 -m tools.sourcing.targets_board . > docs/targets.md
```

Use after goal, index, backlog, or upstream packet changes.

## Leaderboard

Source inputs:

- `library/index/*.aisp`
- `proof-runs/*.aisp`
- goal metadata for status and difficulty context

Commands:

```bash
python3 -m tools.leaderboard --check .
python3 -m tools.leaderboard --write .
python3 -m tools.leaderboard --json .
```

Outputs include `docs/leaderboard.md` and `docs/metrics/community-stats.json`.

## Proof Visualisation

Source inputs:

- `goals/*.aisp`
- `decompositions/*.aisp`
- `library/index/*.aisp`
- `proof-runs/*.aisp`

Commands:

```bash
python3 -m tools.visualiser --check .
python3 -m tools.visualiser --write .
```

Outputs include `docs/proofs-contributors-visualisation.md` and the paired HTML file.

## Rule

If a generated artifact is stale and the source change is intentional, regenerate it with the owning generator. If the source change was accidental, fix the source instead.
