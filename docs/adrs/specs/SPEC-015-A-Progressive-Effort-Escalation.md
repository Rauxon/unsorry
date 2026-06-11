# SPEC-015-A: Progressive Effort Escalation

Implements: [ADR-015](../ADR-015-Progressive-Effort-Escalation.md) · Status: Living · Updated: 2026-06-11

## Resolution

`resolve_model_effort` (SPEC-013-A) now defaults prove-mode effort to the literal token `ladder` instead of `max`. Everything else in SPEC-013-A stands: env overrides win, and any effort — `ladder` included — is dropped fail-soft when the installed CLI does not advertise `--effort`.

## The ladder

`effort_for_attempt <attempt> <resolved_effort>` (swarm/agent.sh) is a pure function printing the effort token for one attempt (`""` = no flag):

| `resolved_effort` | attempt 1 | attempt 2 | attempt 3+ / `top` |
|---|---|---|---|
| `ladder` (prove default) | `high` | `xhigh` | `max` |
| pinned (e.g. `xhigh` via `UNSORRY_EFFORT`) | `xhigh` | `xhigh` | `xhigh` |
| `""` (fail-soft: CLI lacks `--effort`) | — | — | — |

## Call surface

- `call_claude_prove` takes the effort token as its third argument; `run_proof` computes it per attempt and logs `prove attempt <n>/<budget> for <goal> (effort <token>)` so every run's escalation is reconstructable from its log.
- The decomposition proposal call (ADR-009) passes the attempt word `top` — decomposition only fires after the ladder is exhausted, so it always runs at the last rung.
- Prove-mode `UNSORRY_ATTEMPTS` defaults to 3 (one attempt per rung); other modes keep `config.py BUDGET_ATTEMPTS`. An explicit `UNSORRY_ATTEMPTS` wins; attempts past rung 3 stay at `max`.
- The startup log renders the default as `effort=ladder(high→xhigh→max) attempts=3`.

## Acceptance criteria

`test_effort_ladder` (agent.sh self-test, hermetic):

1. ladder rungs: 1 → `high`, 2 → `xhigh`, 3 → `max`;
2. attempts past the last rung, and the word `top`, stay at `max`;
3. a pinned effort short-circuits the ladder at every attempt;
4. the fail-soft empty value pins to "no flag".

Plus `test_model_effort_policy` updated: prove defaults resolve to `fable ladder`. Shellcheck-clean; `--dry-run --prove` startup log shows `model=fable effort=ladder(high→xhigh→max) attempts=3`.
