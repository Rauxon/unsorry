# SPEC-023-A: Proof Provenance and Leaderboard

Implements: [ADR-023](../ADR-023-Proof-Provenance-Leaderboard.md) · Status: Living · Updated: 2026-06-13

## Index surface

New automated proof index records append:

```text
⟦Π:Provenance⟧{
  solver≜<github-login>
  agent≜<swarm-agent-id>
  provider≜<provider-id>
  model≜<effective-model>      # omitted when the provider does not expose it
  effort≜<final-effort>
  attempts≜<successful-attempt-number>
  solve_s≜<proof-and-local-verification-seconds>
}
```

The entire block is optional. Existing index entries remain valid and are
reported as historical/unknown. When the block exists, `solver`, `agent`, and
`provider` are required; the remaining telemetry is optional.

`solver` defaults to the authenticated `gh api user` login and can be
overridden with `UNSORRY_SOLVER`. The agent records the effective Claude model
after fallback. For providers whose default model is not exposed to the
launcher, `model` is omitted rather than guessed.

`solve_s` starts when `run_proof` begins and ends after the successful local
library build, axiom audit, options check, and statement-binding check. It does
not include claim waiting, PR checks, or merge latency.

## Validation

Gate B code `GB019` validates only the optional provenance syntax. Provenance
does not participate in the statement hash, Gate A, proof status, affinity,
candidate ranking, or any other trust decision.

## Leaderboard

`python3 -m tools.leaderboard` deterministically reads `library/index` and
renders:

- verified proof totals and historical/unknown count;
- contributor totals and summed goal-difficulty points;
- provider/model usage and median recorded solve time;
- one row per attributed proof.

`python3 -m tools.leaderboard --check` detects drift in
`docs/leaderboard.md`. Historical records are never attributed from Git commit
authors or PR mergers.

## Future extensions

Failure rates, total compute, CI latency, energy, replicated verification, and
cross-project work units require centralized attempt telemetry. They are
deliberately outside this success-record foundation.
