#!/usr/bin/env bash
# Source this file after filling values for an OpenAI-compatible local run.

export OPENAI_BASE_URL="http://localhost:11434/v1"
export OPENAI_API_KEY="local-placeholder"
export UNSORRY_PROVIDER="openai"
export UNSORRY_MODEL="<model-id>"
export UNSORRY_EFFORT="high"

# Optional attribution override for coordinated runs only.
# export UNSORRY_SOLVER="<github-handle>"

# Example:
# ./swarm/agent.sh --prove-local --goal <goal-id> --provider openai
