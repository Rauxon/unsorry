# Proof Closeout

Goal: `<goal-id>`
Library theorem: `<theorem-name>`
Files changed:
- `library/Unsorry/<file>.lean`
- `library/index/<sha>.aisp`
- `goals/<id>.aisp`

Validation run:
- `lake build UnsorryLibrary --wfail`: `<pass/fail/not run>`
- `lake build UnsorryGoals`: `<pass/fail/not run>`
- `python3 -m tools.gate_b validate .`: `<pass/fail/not run>`
- `python3 -m tools.sourcing.targets_board --check .`: `<pass/fail/not run>`
- `python3 -m tools.leaderboard --check .`: `<pass/fail/not run>`

Notes:
- Statement changed: `no`
- New trust assumptions: `none`
- Telemetry added: `<yes/no/path>`
