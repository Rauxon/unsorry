# Leaderboard Closeout

Scope: `<data/html/svg/automation>`

Files changed:
- `<path>`

Generated artifacts:
- `docs/metrics/community-stats.json`: `<updated/not touched>`
- `docs/leaderboard.md`: `<updated/not touched>`
- `docs/metrics/leaderboard-ui.json`: `<updated/not applicable>`
- `docs/leaderboard.html`: `<updated/not applicable>`
- `docs/leaderboard.svg/png`: `<updated/deferred/not applicable>`

Validation:
- `python3 -m pytest tools/leaderboard -q`: `<pass/fail/not run>`
- `python3 -m tools.gate_b validate .`: `<pass/fail/not run>`
- `python3 -m tools.leaderboard --check .`: `<pass/fail/not run>`

Notes:
- Attribution source: `<recorded solver only / unknown preserved>`
- README image: `<implemented/deferred>`
- Automation policy: `<proof PR regen / drift-check plus bot PR / undecided>`
