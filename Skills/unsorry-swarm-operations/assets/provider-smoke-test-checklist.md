# Provider Smoke-Test Checklist

- [ ] Confirm provider credentials or local endpoint are intentionally configured.
- [ ] Run `./swarm/agent.sh --self-test`.
- [ ] If using `-pi`, run `python3 -m tools.llm_providers.pi_config resolve --model "<model name>"`.
- [ ] Run `pytest tools/llm_providers -q` after provider code changes.
- [ ] Use `--prove-local --goal <goal-id>` before coordinated `--prove`.
- [ ] Confirm the model supports tool calls before coordinated proof mode.
- [ ] Report provider, model, effort, and whether the run had remote side effects.
