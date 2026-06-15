# SPEC-050-A: Autonomous Trunk Skeleton

Implements: [ADR-050](../ADR-050-Autonomous-Trunk-Skeleton.md) | Status: Proposed | Updated: 2026-06-15

This spec defines the reusable repository skeleton for autonomous,
multi-agent work orchestration. It is not a separate framework yet. It is the
copyable contract a new project can use before any extraction into a CLI,
template repository, or hosted service.

## 1. Purpose

The skeleton gives a project the same generic operating model that unsorry
uses for Lean proofs:

```text
publish work -> claim -> isolated work -> local verify -> PR
  -> machine gates -> auto-merge or reject -> post-merge refresh
  -> evidence -> next work
```

The skeleton is domain-agnostic. It coordinates work; it does not decide truth.
Truth belongs to the adapter verifier defined by ADR-030.

## 2. Required Project Structure

A conforming project SHOULD provide these logical areas, even if exact paths
vary:

| Area | Purpose |
|------|---------|
| `work/` or domain equivalent | Canonical work-unit records on protected trunk |
| `claims/` branch or equivalent lease store | Ephemeral claim/lease state |
| `evidence/` or `runs/` | Terminal run facts and verifier evidence |
| `generated/` or `docs/metrics/` | Generated boards, leaderboards, and status artifacts |
| `adapters/<domain>/` | Domain-specific generator/verifier/assimilator |
| `tools/skeleton/` | Generic claim, select, submit, audit, and evidence helpers |
| `.github/workflows/` | Gate, PR policy, post-merge refresh, and reaper workflows |
| `docs/adrs/` and `docs/adrs/specs/` | Decision and implementation records |
| `docs/operations/` or `docs/compliance/` | Runbooks, settings audit, and risk/evidence notes |

Unsorry's current paths are the Lean adapter instance of this layout, not the
only allowed layout.

## 3. Lifecycle

The generic work-unit lifecycle is:

```text
open
  -> claimed
  -> in_progress
  -> pr_opened
  -> gated
  -> merged
```

Failure exits are:

```text
in_progress -> released
in_progress -> demoted
in_progress -> decomposed
pr_opened   -> rejected
gated       -> failed
```

Rules:

1. `open` units are selected from protected trunk.
2. `claimed` means a lease exists and has not expired.
3. `in_progress` work happens outside the operator's dirty checkout.
4. `pr_opened` contains one logical change.
5. `gated` means required machine checks have run.
6. `merged` means the verifier policy accepted the contribution.
7. `released`, `demoted`, and `decomposed` are terminal facts for that attempt,
   not silent failures.

## 4. Claim and Lease Contract

The skeleton MUST define a lease mechanism with:

- stable work-unit id,
- agent identity,
- creation timestamp,
- TTL,
- renewal or retry semantics,
- first-writer-wins or equivalent conflict rule,
- reaper for expired claims,
- proof that claims are not the source of truth for accepted work.

The initial implementation MAY use a dedicated git branch, as unsorry does.
Alternative implementations MAY use a database or queue service, but that is a
separate substrate decision. The skeleton contract is the lease semantics, not
the storage backend.

## 5. PR and Trunk Policy

A conforming project SHOULD use:

- protected `main` or equivalent trunk,
- no direct commits to trunk except explicitly-scoped generated-artifact
  refreshes or emergency procedures,
- short-lived branches from trunk,
- one logical change per PR,
- enforced PR title taxonomy,
- squash merge for accepted work,
- branch cleanup after merge,
- CODEOWNER or equivalent review on trust-bearing paths.

GitFlow-style long-lived integration and release branches are not the skeleton
default. They add staging ceremony and merge surfaces that work against
high-throughput autonomous contribution. A domain may add release branches only
as an adapter or deployment policy, not as the core coordination model.

## 6. Gate Model

The skeleton distinguishes five gate classes:

| Gate class | Blocks merge? | Owner |
|------------|---------------|-------|
| Verifier gate | Yes | Adapter |
| Hygiene gate | Usually yes | Skeleton or adapter |
| Supply-chain gate | Yes for trust-bearing paths | Skeleton |
| Policy gate | Yes when risk policy says so | Skeleton |
| Advisory gate | No | Project |

The verifier gate is the acceptance authority. It MUST publish evidence that
can be inspected after merge.

Adapters declare one of ADR-030's verifier tiers:

- `VERIFIED`: deterministic checker; one accepted result closes the unit.
- `SCORED`: verifier returns score; best accepted result wins.
- `CONSENSUS`: no cheap deterministic verifier; require quorum/redundancy.

Projects MUST NOT label a weak or subjective verifier as `VERIFIED` merely to
obtain auto-merge.

## 7. Post-Merge Generated Artifacts

Generated aggregate artifacts SHOULD refresh after merge, not inside every PR,
when concurrent PRs would otherwise conflict on the same files.

The refresh workflow MUST:

1. run on trunk changes that affect the artifact,
2. check for drift,
3. regenerate deterministically,
4. push a docs/generated-only commit with a skip-CI marker where appropriate,
5. retry after non-fast-forward races,
6. degrade to a warning when the required push credential is unavailable.

The canonical source of truth remains the work/evidence corpus, not the
generated board.

## 8. Settings and Trust-Bearing Surfaces

A skeleton project MUST document settings that cannot be represented fully in
git:

- branch protection and required check names,
- force-push and deletion restrictions,
- Actions permissions and allowed actions policy,
- CODEOWNER review settings,
- protected tags/releases,
- admin or refresh tokens and their scopes,
- runner pools and secret exposure rules.

The project SHOULD add a settings-drift audit that reports whether these match
the documented policy. A checklist without periodic verification is acceptable
only during early single-maintainer operation and must be recorded as accepted
risk.

## 9. Evidence and Compliance Hooks

The skeleton SHOULD produce a periodic evidence pack containing:

- merged PRs by category,
- gate pass/fail summaries,
- stale claims and reaper actions,
- generated-artifact drift reports,
- workflow/action pin status,
- protected-branch/settings audit summary,
- secrets/token rotation metadata without secret values,
- open risks and accepted exceptions.

This does not make a project ISO/IEC 27001 certified. It gives an ISMS owner
evidence for change management, secure development, access control,
configuration management, logging, supplier/toolchain risk, and continual
improvement.

## 10. Adapter Contract

Each adapter MUST define:

```text
select(context) -> WorkUnit
generate(unit, context) -> Candidate
verify(unit, candidate) -> Verdict
assimilate(candidate) -> CorpusChange
decompose(unit, evidence) -> [WorkUnit] | unsupported
```

The adapter MUST also declare:

- verifier tier,
- required tools and pinned versions,
- local verification command,
- central CI verification command,
- artifact/evidence format,
- acceptance criteria,
- failure taxonomy,
- whether auto-merge is allowed.

## 11. Scaling Notes

The skeleton is designed for many agents, but hundreds of agents require extra
controls:

- GitHub API rate handling,
- PR and branch cleanup,
- runner-pool capacity awareness,
- per-agent and per-work-unit concurrency caps,
- claim queue sharding,
- retry/backoff policy,
- budget and quota enforcement,
- abuse detection,
- dashboarding for claims, PRs, gates, costs, and stale work.

Those controls are expected follow-up decisions, not hidden guarantees of the
first skeleton.

## 12. Validation

The skeleton is valid when:

1. the current Lean swarm can be described as an instance of this spec without
   weakening Gate A,
2. a new non-Lean pilot can bootstrap by supplying only an adapter and project
   policy,
3. generated artifacts can be moved post-merge without PR conflict churn,
4. a project owner can list trust-bearing GitHub settings and evidence outputs,
5. the skeleton documentation is sufficient for another maintainer to create a
   new project without reading all Lean-specific ADRs.

## 13. Out of Scope

- A hosted scheduler or central queue service.
- A marketplace or registry for third-party adapters.
- A billing model for donated or pooled agent compute.
- Certification to ISO/IEC 27001 or any other compliance standard.
- Replacing unsorry's Lean-specific soundness gates.
