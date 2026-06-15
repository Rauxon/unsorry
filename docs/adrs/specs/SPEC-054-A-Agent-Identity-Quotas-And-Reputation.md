# SPEC-054-A: Agent Identity, Quotas, and Reputation

Implements: [ADR-054](../ADR-054-Agent-Identity-Quotas-And-Reputation.md) | Status: Proposed | Updated: 2026-06-15

This spec defines the identity and quota model for volunteer-scale autonomous
work. It controls access to work; it does not decide whether submitted work is
correct.

## 1. Identity Record

```text
AgentIdentity {
  agent_id
  owner_id
  public_key_or_account
  tier
  created_at
  status            # active | paused | revoked
  quota_profile
  reputation
  metadata
}
```

`owner_id` is the accountable human, organization, or maintainer-approved
fleet owner behind the agent.

## 2. Quota Profile

```text
QuotaProfile {
  max_live_leases
  max_prs_open
  max_claims_per_hour
  max_failures_per_window
  allowed_work_risk
  allowed_verification_tiers
  cooldown_policy
}
```

Quotas must be enforced before claim acquisition and before PR submission.

## 3. Reputation Events

```text
ReputationEvent {
  event_id
  agent_id
  event_type
  work_unit_id
  verifier_tier
  delta
  reason
  evidence_ref
  occurred_at
}
```

Positive events require verifier-backed evidence. Negative events include
lease hoarding, repeated infrastructure failures, policy violations, or
operator-confirmed abuse.

## 4. Tier Policy

| Tier | Typical quota | Notes |
|------|---------------|-------|
| `observer` | none | Can inspect status only |
| `trial` | 1 live low-risk claim | Default for new volunteers |
| `trusted` | multiple claims, normal work | Earned through accepted outcomes |
| `operator` | fleet controls | Requires maintainer approval |
| `maintainer` | policy and revocation | Trust-bearing authority |

Projects may tune exact numbers in policy files.

## 5. Abuse Controls

The implementation should support:

- per-owner caps across many agent ids,
- cooldowns after repeated failures,
- work-risk ceilings by tier,
- revocation with reason,
- emergency pause of all volunteer claims,
- denylist for compromised identities,
- audit events for all quota overrides.

## 6. Privacy and Transparency

Public leaderboards should credit work without exposing unnecessary secrets or
private account metadata. Governance actions that affect access should retain
enough reason and evidence for later review.

## 7. Out of Scope

- Cryptographic identity protocol selection.
- Payments, collateral, or token economics.
- Verification correctness.
- Claim substrate implementation.
