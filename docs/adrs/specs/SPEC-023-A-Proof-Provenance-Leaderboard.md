# SPEC-023-A: Proof Provenance and Community Statistics

Implements: [ADR-023](../ADR-023-Proof-Provenance-Leaderboard.md) · Status: Living · Updated: 2026-06-13

## Verified-output surface

New automated proof index records append an optional provenance block:

```text
⟦Π:Provenance⟧{
  solver≜<github-login>
  agent≜<swarm-agent-id>
  provider≜<provider-id>
  model≜<effective-model>      # omitted when not exposed
  effort≜<final-effort>
  attempts≜<successful-attempt-number>
  solve_s≜<proof-and-local-verification-seconds>
}
```

Existing index entries remain valid and are reported as historical/unknown.
`solver` defaults to the authenticated `gh api user` login and can be
overridden with `UNSORRY_SOLVER`. Unknown models are omitted, never guessed.

## Terminal-run fact table

Every coordinated proof run that reaches a durable outcome PR appends:

```text
proof-runs/<goal>.<agent>.<run-id>.aisp

𝔸5.1.run.<goal>.<agent>.<run-id>@<date>
γ≔unsorry.proof.run
⟦Ω:Run⟧{id≜<run-id>; goal≜<goal>; agent≜<agent>; outcome≜proved|decomposed|failed}
⟦Π:Provenance⟧{solver≜<github-login>; provider≜<provider>; model≜<optional>; effort≜<optional>}
⟦Γ:Goal⟧{goal≜<goal>}
⟦Λ:Metrics⟧{attempts≜<positive-int>; solve_s≜<non-negative-int>; ended≜<ISO-8601-UTC>}
⟦Σ:Artifact⟧{sha≜<proved-index-sha-or-empty>}
⟦Ε⟧⟨δ≜0.60;τ≜◊⁺⟩
```

The `⟦Γ:Goal⟧` goal-link is one of the five canonical AISP-5.1 blocks
(Ω/Σ/Γ/Λ/Ε); carrying it keeps the record valid under the generic upstream
validator (`aisp-validator`, ADR-003) — without it the advisory cross-check
rejects every run for a missing Γ block.

The fact is committed in the proof PR, accepted decomposition PR, or
affinity-demotion PR. If proof attempts were exhausted but decomposition then
hits infrastructure, a telemetry-only PR records the failed proof run without
changing goal state. Failed attempts are derived without redundant storage:

- proved run: `attempts - 1`;
- decomposed or failed run: `attempts`.

Infrastructure failures are excluded under ADR-016 because they provide no
evidence about goal difficulty or provider capability. Local-only smoke runs
are excluded because they perform no remote operation. A run that fails before
the first provider attempt is also excluded.

`solve_s` starts when `run_proof` begins and ends at local proof verification or
terminal proof failure. It excludes claim waiting, decomposition generation,
PR checks, and merge latency.

## Validation

Gate B `GB019` validates optional successful-proof provenance. `GB020` validates
terminal-run identity, goal references, outcome, attribution, attempts, elapsed
time, completion timestamp, and artifact linkage. Neither surface participates
in statement hashing, Gate A, proof status, affinity, candidate ranking, or any
other trust decision.

## Statistics products

`python3 -m tools.leaderboard --write` deterministically writes:

- `docs/metrics/community-stats.json`: schema-versioned base statistics;
- `docs/leaderboard.md`: a human view generated from the same calculations.

`--json` prints the machine-readable statistics and `--check` detects drift in
both generated files.

The base statistics include:

- verified-output and run-telemetry coverage;
- terminal outcome counts, run success rate, attempt yield, failed attempts,
  total/median/p90 solve time, and successes per recorded run hour;
- queue status and difficulty distributions;
- contributor, provider/model, effort-rung, difficulty, and daily cohorts;
- goal-level accumulated runs, failed attempts, and recorded time;
- the latest terminal runs for operational inspection.

Leaderboard rank uses verified proof count, then summed goal-difficulty points.
Failed effort is visible but cannot improve rank, which avoids rewarding
deliberate repeated failure.

## Interpretation limits

Rates use only logged post-adoption runs. Historical failures are never inferred
from Git authorship, commits, or PR mergers. Provider/model comparisons are
observational and confounded by goal difficulty, contributor choices, retries,
and small sample sizes.

The completion timestamp supports future trend and retention analysis. Better
cost-effectiveness, retry-escalation, hardware, energy, and token analysis would
require additional per-attempt fields. Cross-project work-unit credits would
also require an anti-abuse and verification design before becoming rewards.
