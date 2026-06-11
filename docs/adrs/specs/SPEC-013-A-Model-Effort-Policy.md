# SPEC-013-A: Model/Effort Plumbing for Proof Runs

Implements: [ADR-013](../ADR-013-Model-Effort-Policy.md) · Status: Living · Updated: 2026-06-11

## Resolution

`resolve_model_effort <mode> <model_env> <effort_env> <cli_help_text>` (swarm/agent.sh) is a pure function printing `"<model> <effort>"` (`-` = no effort flag):

- mode `prove` → model defaults `fable`, effort defaults `ladder` (the ADR-015 per-attempt escalation — see SPEC-015-A; was `max` before ADR-015)
- mode `translate` → model defaults `sonnet`, effort defaults unset
- `UNSORRY_MODEL` / `UNSORRY_EFFORT` override either default; a set `UNSORRY_EFFORT` pins every attempt
- **fail-soft**: any effort (default or explicit, `ladder` included) is dropped when `<cli_help_text>` does not advertise `--effort` — contributor agents on older CLIs must not break

`main()` resolves once at startup (probing `claude --help`, tolerant of a missing binary in `--dry-run`), exports the result into `UNSORRY_MODEL` / `UNSORRY_EFFORT`, and logs `model=… effort=…` so every run records its config.

## Call surface

Per-attempt `--effort` args are computed by `effort_for_attempt` (SPEC-015-A) at the proof-surface call sites only:

- `call_claude_prove` (prove step 5) — effort token passed per attempt
- the decomposition proposal call in `decompose_goal` (ADR-009) — always the top rung

The translate call sites take no effort flag. Valid effort tokens are whatever the installed CLI accepts (2.1.172+: `low, medium, high, xhigh, max`); the script passes the value through without its own whitelist so new CLI tiers need no script change.

## Acceptance criteria

`test_model_effort_policy` in the agent.sh self-test suite (hermetic, no network):

1. prove defaults → `fable ladder` (ADR-015)
2. translate defaults → `sonnet -`
3. env overrides win (`sonnet high`)
4. fail-soft drop on a CLI without `--effort` (default and explicit effort both)
5. explicit effort on translate honoured when supported

Plus: shellcheck-clean; `--dry-run --prove` startup log shows `model=fable effort=ladder(high→xhigh→max)`.
