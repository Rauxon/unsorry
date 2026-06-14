# Swarm Run Report

Goal: `<goal-id>`
Mode: `<self-test/dry-run/prove-local/prove/translate-only/supervised>`
Provider: `<provider>`
Model: `<model or unknown>`
Local or coordinated: `<local/coordinated>`

Side effects:
- Claim created: `<no/yes/path>`
- Branch pushed: `<no/yes/name>`
- PR opened: `<no/yes/url>`
- Telemetry added: `<no/yes/path>`

Outcome: `<proved/decomposed/failed/infrastructure-failure/smoke-only>`

Validation:
- `./swarm/agent.sh --self-test`: `<pass/fail/not run>`
- `python3 -m tools.gate_b validate .`: `<pass/fail/not run>`
- `lake build UnsorryLibrary --wfail`: `<pass/fail/not run>`
- `python3 -m tools.leaderboard --check .`: `<pass/fail/not run>`

Notes:
- `<short operational note>`
