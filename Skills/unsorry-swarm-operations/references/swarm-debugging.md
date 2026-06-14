# Swarm Debugging

## First Checks

```bash
git status --short --branch
./swarm/agent.sh --self-test
python3 -m tools.gate_b validate .
```

For provider issues:

```bash
python3 -m tools.llm_providers.pi_config resolve --model "<model name>"
pytest tools/llm_providers -q
```

For Lean/proof issues:

```bash
lake build UnsorryLibrary --wfail
lake build UnsorryGoals
```

## Common Failures

- No write access: use `--prove-local`; coordinated `--prove` needs shared repo write access.
- Claim collision: first push lost; fetch the claims branch and choose another goal.
- Expired claim: let the reaper handle it or validate with an injected `--at` time.
- Provider lacks tool calls: use a tool-capable model for coordinated proof mode.
- Generated analytics stale: run the matching `--check`, then `--write` if the source change is intentional.
- Local proof works but PR fails: inspect Gate A statement binding, axiom audit, and goal immutability.

## Preserve Evidence

When debugging a run, keep the goal id, provider, model, branch, PR number, claim file, terminal outcome, and exact failing command. Avoid deleting telemetry or generated evidence unless it is clearly a local-only artifact.
