# Swarm Runbook

## Local Safe Modes

Use these when experimenting, working from a fork, or diagnosing provider behavior:

```bash
./swarm/agent.sh --self-test
./swarm/agent.sh --dry-run --prove --once
./swarm/agent.sh --prove-local --goal <goal-id> --provider <provider>
```

`--prove-local` should not fetch, claim, push, or open a PR. It works from committed local `HEAD`.

## Coordinated Modes

Use only with write access to the shared repository:

```bash
./swarm/agent.sh --prove --once --provider <provider>
./swarm/agent.sh --translate-only --once
```

Coordinated proof runs may push claims, create branches, open PRs, and add proof-run telemetry when a durable outcome is reached.

## Supervised Runs

Use the supervisor for unattended goal-tree closure:

```bash
./swarm/supervise.sh --prove --goal <goal-id>
```

The supervisor adds backoff and PR hygiene around the same proof loop. Use `--self-test` before changing supervisor behavior.

## Side Effect Matrix

| Mode | Claims | Branch/PR | Telemetry | Intended use |
|---|---:|---:|---:|---|
| `--self-test` | no | no | no | environment/script check |
| `--dry-run --prove --once` | no | no | no | selection preview |
| `--prove-local` | no | no | no | local proof smoke test |
| `--prove --once` | yes | yes | yes on durable outcome | coordinated contribution |
| `--translate-only --once` | yes | yes | usually no proof-run | formalisation loop |
| `supervise.sh --prove` | yes | yes | yes on durable outcome | unattended closure |

If a run unexpectedly has remote side effects, stop and inspect `swarm/agent.sh` and the current git branch before retrying.
