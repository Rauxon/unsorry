# Leaderboard Implementation Checklist

- [ ] Read ADR-023 and SPEC-023-A.
- [ ] Confirm `python3 -m tools.leaderboard --json .` reflects current source records.
- [ ] Regenerate stale existing outputs with `python3 -m tools.leaderboard --write .`.
- [ ] Add or update tests for UI payload generation.
- [ ] Generate `docs/metrics/leaderboard-ui.json` from `base_stats(root)`.
- [ ] Make `--check` cover every generated leaderboard artifact.
- [ ] Move or generate browser page as `docs/leaderboard.html`.
- [ ] Replace placeholder seed data with generated JSON fetch.
- [ ] Link contributor names or avatars to GitHub profiles.
- [ ] Use deterministic avatar URLs, not GitHub API calls.
- [ ] Preserve historical/unknown attribution.
- [ ] Run `python3 -m pytest tools/leaderboard -q`.
- [ ] Run `python3 -m tools.gate_b validate .`.
- [ ] Run `python3 -m tools.leaderboard --check .`.
