# SPEC-016-A: Infrastructure-Failure Guard

Implements: [ADR-016](../ADR-016-Infrastructure-Failure-Guard.md) · Status: Living · Updated: 2026-06-11

## Classifier

`classify_call_failure <duration_s> <fastfail_s> <probe_rc>` (swarm/agent.sh) is a pure function printing `infra` or `real`:

- `infra` ⇔ `duration < fastfail` **and** `probe_rc != 0`
- everything else is `real` (boundary `duration == fastfail` is real)

`cli_health_probe` is the probe: a `timeout 90` claude call on the **cheap model** (it must not draw from the premium budget whose exhaustion it diagnoses), invoked only after a fast-failed call — the healthy path never pays for it.

`UNSORRY_FASTFAIL` (default 240s, env-overridable, validated integer): a real prove attempt cannot fail faster — the model has to at least read the goal and run a build.

## Propagation

Return code 2 = infrastructure failure, threaded through the prove path:

- `run_proof`: a failed `call_claude_prove` is timed; fast death + failed probe → `return 2` immediately (remaining ladder rungs are not burned).
- `decompose_goal`: the proposal call is timed; an unusable split (<2 subs) from a fast-dead call with a failed probe → `return 2` instead of falling back.
- `prove_goal`: rc 2 from `run_proof` → release claim, **no** `prove-failed` event, **no** decompose, **no** demote, `return 2`. rc 2 from `decompose_goal` (real attempts, infra during decompose) → the honest `prove-failed` stands but **no demote**, `return 2`.
- main loop: rc 2 from `prove_goal` → log and `exit 3` (documented exit code) — every further cycle would fail identically; the orchestrator reschedules.

The translate arm is unchanged (cheap model; an outage there has never poisoned the queue).

## Acceptance criteria

`test_infra_failure_classifier` (agent.sh self-test, hermetic):

1. fast death + failed probe → `infra`;
2. fast death + healthy probe → `real`;
3. slow death (≥ threshold) → `real` even with a failed probe;
4. boundary `duration == fastfail` → `real`.

Shellcheck-clean. Incident record: the 2026-06-11 quota outages (#165 restore; #168–#181 demote churn) are the motivating production failures — post-guard, an outage must produce *zero* goal-record writes.
