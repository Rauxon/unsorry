# SPEC-017-A: Swarm Supervisor and In-Flight-Work Guard

Implements: [ADR-017](../ADR-017-Swarm-Supervisor.md) · Status: Living · Updated: 2026-06-11

## Supervisor (`swarm/supervise.sh`)

`./swarm/supervise.sh --prove --goal <id> [agent.sh args]` runs agent.sh in a loop until the scope closes. Policy is the pure function `next_action <agent_rc> <consec_infra> <base> <cap> <short>`:

| agent exit | meaning | action |
|---|---|---|
| 0 | pool empty | scope closed → **done**; scope open → wait `UNSORRY_SUP_FLIGHT_WAIT` (180s) for PRs/sweeps, re-run; no scope → done |
| 1 | cycle failure | retry after `UNSORRY_SUP_SHORT_WAIT` (120s) |
| 2 | configuration | **fatal** — human required |
| 3 | infrastructure (ADR-016) | backoff `UNSORRY_SUP_BASE_BACKOFF`·2^consec, capped `UNSORRY_SUP_MAX_BACKOFF` (300s → 3600s), retry |

`scope_closed <goals_dir> <goal>`: 0 iff the goal record and every `<goal>-s*` descendant is `status≜proved`. The run budget `UNSORRY_SUP_MAX_RUNS` (50) bounds total agent invocations. `git pull --ff-only` precedes every run and every closure check.

## PR hygiene (every wait, best-effort)

- `duplicate_prs` (pure, stdin `number\tcreatedAt\ttitle`): prints every open prove PR that is not the *oldest* for its goal (key = title to the first `:`). Those are closed with a comment — the #184/#185 resolution, automated.
- Any open scoped PR with `mergeable == CONFLICTING` is loudly logged: GitHub runs **no checks** on a conflicted PR, so an armed auto-merge sits silently forever (the #166 failure mode). Resolution stays with the maintainer — goal-record conflicts can need semantic judgement (proved record vs demote noise).
- All `gh` failures degrade to a log line; hygiene never takes the supervisor down.

## Claim guard (agent.sh)

`open_prove_pr_exists <goal>`: true iff an open PR matches `"prove(<goal>):" in:title`. In prove mode (not `--dry-run`) the candidate loop skips such goals: their claim was released at PR-open (ADR-004 lifecycle), so the claims branch alone cannot represent in-flight work. Fail-open: a `gh` error returns "unknown" and claiming proceeds — selection never depends on API health.

## Acceptance criteria

`./swarm/supervise.sh --self-test` (hermetic): `test_next_action` (done-check/fatal/retry; backoff doubling and cap), `test_scope_closed` (open sub holds scope; proved tree closes; blocked grandchild holds; empty/missing scope never closes), `test_duplicate_prs` (oldest survives regardless of input order; singletons untouched).

`./swarm/agent.sh --self-test`: `test_open_pr_claim_guard` (stubbed `gh`: open PR → skip; none → proceed; gh failure → fail open). 32 tests green.

CI: agent-lint shellchecks, syntax-checks and self-tests **both** scripts.
