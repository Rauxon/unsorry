# SPEC-058-A: Runner Pool Segmentation and Verification Capacity Governance

Implements: [ADR-058](../ADR-058-Runner-Pool-Segmentation-And-Verification-Capacity.md) | Status: Proposed | Updated: 2026-06-16

This spec defines the first operating contract for routing unsorry CI and
agent work across GitHub-hosted and namespace.so runner pools.

## 1. Runner Surfaces

### GitHub-hosted cheap lane

Use GitHub-hosted `ubuntu-latest` for:

- path detection,
- required-check aggregation,
- PR title, label, and scope checks,
- ADR/spec/documentation checks,
- generated-board refreshes,
- lightweight fork intake checks,
- any job that must not consume namespace verifier capacity.

These jobs must not become the sole source of a Lean soundness verdict.

### Namespace trusted verifier lane

Use namespace.so profiles for:

- Gate A Lean build/audit/replay jobs,
- central re-checks defined by ADR-049,
- verifier jobs that can admit content to `UnsorryLibrary`,
- evidence-producing verifier jobs that depend on namespace cache volumes or
  profile sizing.

Namespace runner logs, profile sizing, cache volumes, and queue behavior are
part of the operator-visible verifier surface.

## 2. Current Namespace Profiles

| Profile | Intended size | Use |
|---------|---------------|-----|
| `namespace-profile-unsorry-1` | 4 GB | routine incremental Gate A verification |
| `namespace-profile-unsorry-2` | 16 GB | forced full replay and olean-invalidating changes |

The workflow must route by verification workload, not by trust in the author.
A trusted maintainer PR that changes `lean-toolchain`, `lakefile*`, or
`lake-manifest.json` is heavy. A fork PR that touches only docs remains cheap
until it reaches a verifier stage.

## 3. Required Routing Contract

`.github/workflows/gate-a.yml` must preserve this shape:

```text
detect:              GitHub-hosted
gate-a-prepare:      namespace profile selected by detect
gate-a-audit:        namespace profile selected by detect
gate-a-replay:       namespace profile selected by detect
gate-a-archive:      namespace profile selected by detect when archive paths changed
gate-a aggregate:    GitHub-hosted
```

The `detect` job selects:

```text
if olean-invalidating paths changed:
  profile = namespace-profile-unsorry-2
else:
  profile = namespace-profile-unsorry-1
```

The olean-invalidating set is:

```text
lean-toolchain
lakefile.toml
lakefile.lean
lake-manifest.json
```

Changes to `tools/gate_a/**` and `.github/workflows/gate-a.yml` remain
Lean-relevant and trust-bearing, but they do not automatically select the heavy
profile unless they also invalidate oleans.

## 4. GitHub-Hosted Verifier Pilot Policy

GitHub-hosted `ubuntu-latest` may be evaluated as a routine verifier runner
because it can provide more plan-level concurrency than a small namespace
profile. It must not replace `namespace-profile-unsorry-1` as the required Gate
A verifier lane without evidence.

A valid pilot must be non-merge-blocking or limited to an explicitly approved
test branch, and must report:

- median and p95 wall time for `gate-a-prepare`, `gate-a-audit`, and
  `gate-a-replay`,
- cache-hit behavior for mathlib and `.lake/build`,
- queue wait time,
- failure and retry rate,
- whether `UNSORRY_REPLAY_CHUNK=6` is still required,
- whether GitHub-hosted storage is enough for the workflow,
- whether logs and job metadata are sufficient for operator debugging,
- cost/minute impact compared with namespace,
- effect on the existing open PR queue.

The pilot may become a later implementation PR if it shows that GitHub-hosted
runners are faster or cheaper without weakening the ADR-049 central re-check
contract. Until then, GitHub-hosted runners remain the cheap/intake and
aggregation lane, while namespace remains the trusted verifier lane.

## 5. Live Cutover Policy

Runner segmentation is a live operations change. It must handle existing PRs
and queued jobs, not only new work.

### 5.1 Required-check continuity

The cutover must preserve required check names:

```text
gate-a
gate-b
```

Branch protection must not be changed merely to adopt this runner policy. The
aggregate `gate-a` job may continue to run on GitHub-hosted runners because it
only aggregates the namespace verifier jobs.

### 5.2 Existing PR handling

At cutover time, open PRs fall into four classes:

| PR state | Handling |
|----------|----------|
| Green and mergeable | May merge without rerun; verifier contract did not weaken |
| Queued | Let run drain unless queue pressure requires manual cancellation |
| In progress | Do not cancel unless superseded or clearly stuck |
| Failed/stale | Maintainer chooses rerun, rebase, or close/recreate |

Existing PRs do not need to be mass-rebased only to adopt comments or docs. A
material workflow routing change may require a rebase/rerun, but this ADR's
initial adoption is policy and documentation over the existing routing shape.

### 5.3 Queue drain procedure

Before changing actual runner profile sizes, operators should:

1. Capture the current open PR count and queued Gate A count.
2. Pause new autonomous proof PR creation if the namespace queue is already
   saturated.
3. Keep both `namespace-profile-unsorry-1` and
   `namespace-profile-unsorry-2` available.
4. Let existing in-progress Gate A jobs finish.
5. Cancel only superseded or clearly stuck runs.
6. Confirm new PRs route routine work to `unsorry-1` and olean-invalidating
   work to `unsorry-2`.
7. Wait for one scheduled `gate-a-full-replay` run after the cutover.
8. Record the cutover event with profile sizes and queue state.

The pause in step 2 can be manual at first. ADR-053/ADR-054 should later make
it an explicit claim/quota control.

### 5.4 Rollback

Rollback must preserve the required contexts. Valid rollback actions are:

- resize `unsorry-1` upward without changing the workflow,
- route forced full replay temporarily to `unsorry-2`,
- pause new autonomous proof PR creation,
- re-run failed Gate A jobs after capacity is restored,
- revert the workflow routing PR if a routing change, not capacity, caused the
  failure.

Do not roll back by disabling Gate A, removing branch protection, or accepting
a fork/client verifier result.

## 6. Fork Intake Policy

Fork PRs are safe from a soundness perspective only because ADR-049 keeps the
central verifier authoritative. They are still a capacity and abuse risk.

Before a fork PR can spend namespace verifier capacity, the system should run
cheap GitHub-hosted intake checks:

- path classification,
- whether Lean-relevant files changed,
- PR size,
- contributor status or reputation tier,
- whether maintainer approval is required,
- whether a duplicate proof target is already in flight.

Until ADR-054 quotas are implemented, maintainer approval is the default
governor for unknown fork contributors reaching namespace verifier jobs.

## 7. Agent and Generated-Artifact Policy

Agent exploration, proof attempts, retries, and candidate generation are not
trusted verifier work. They should run:

- locally on the contributor/agent machine,
- on a separate agent worker pool,
- or on GitHub-hosted jobs only when cheap and non-secret.

Generated artifacts should default to GitHub-hosted runners unless the artifact
is verifier evidence that requires namespace cache state or trusted verifier
context.

## 8. Capacity Math

If a verifier run takes six minutes of exclusive namespace capacity, one runner
provides about ten verifier slots per hour:

```text
60 minutes / 6 minutes per PR = 10 PR verifier slots per hour
```

Ten active contributors can exceed that quickly. Therefore:

- cheap checks must short-circuit non-Lean PRs before namespace use,
- superseded PR runs must be cancelled,
- full replay must stay rare and isolated,
- unknown fork and agent work must have quota or approval,
- queue depth and median wait time should be visible to operators.

## 9. Observability Requirements

The operator dashboard or generated status pack should report:

- active GitHub-hosted cheap-lane jobs,
- active namespace verifier jobs,
- queued namespace verifier jobs,
- average verifier wait time,
- per-profile runner-minute usage,
- number of cancelled superseded runs,
- number of fork PRs waiting for approval,
- number of heavy-profile runs triggered by olean-invalidating changes.

GitHub-hosted concurrency is useful but plan-dependent. The repository should
not encode a fixed GitHub-hosted concurrency number as a correctness
assumption.

## 10. Safety Requirements

- A GitHub-hosted cheap check may block or classify work, but must not admit
  Lean proofs.
- A namespace verifier job must never trust contributor-supplied oleans as a
  soundness input.
- The aggregate required check may run on GitHub-hosted runners only because it
  depends on namespace verifier job results.
- Fork PR verifier access must be governed by approval or quota until ADR-054
  is implemented.
- Runner profile size may change, but workflow comments and specs must be
  updated in the same PR as an intentional sizing change.
- GitHub-hosted verifier routing must be introduced as a measured pilot before
  it can become the required Gate A lane.

## 11. Acceptance Criteria

ADR-058 is implemented when:

- Gate A detection and aggregation remain on GitHub-hosted runners.
- Gate A verifier jobs remain on namespace profiles.
- Routine incremental verifier work routes to `namespace-profile-unsorry-1`.
- Olean-invalidating full replay routes to `namespace-profile-unsorry-2`.
- Existing docs/specs describe the current 4 GB / 16 GB namespace profile split.
- Fork-support work references this runner policy before enabling automated
  namespace verifier spend for unknown contributors.
- The cutover procedure accounts for open PRs, queued Gate A runs, and
  in-progress namespace jobs.
- Required check names remain stable through the transition.
- A future GitHub-hosted verifier migration has a measured pilot before any
  required verifier context is moved.

## 12. Out of Scope

- Purchasing a larger runner plan.
- Replacing namespace.so.
- Implementing ADR-054 reputation and quota storage.
- Rewriting Gate A control flow.
- Making GitHub-hosted runner concurrency a guaranteed service-level objective.
