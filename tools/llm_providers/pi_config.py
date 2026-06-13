"""Resolve an OpenAI-compatible endpoint from pi-coder's models.json (ADR-025).

pi-coder (`@earendil-works/pi-coding-agent`) stores provider/model definitions in
`~/.pi/agent/models.json`:

    { "providers": { "<name>": {
        "baseUrl": "http://localhost:11434/v1",
        "api": "openai-completions" | "openai-responses" | "anthropic-messages" | ...,
        "apiKey": "ollama" | "$ENV_VAR" | "${ENV_VAR}",
        "models": [ { "id": "llama3.1:8b", "name": "Llama 3.1 8B (Local)" }, ... ]
    } } }

`resolve(model_name)` finds a model by `name` (falling back to `id`), checks that its
effective `api` is `openai-completions` (the only shape unsorry's Chat-Completions
client speaks), and returns `(base_url, api_key, model_id)`. `agent.sh`'s `-pi` handler
exports these as OPENAI_BASE_URL / OPENAI_API_KEY / UNSORRY_MODEL and runs the existing
OpenAI path — pi-awareness stops here. Pure stdlib; no network.
"""
import argparse
import json
import os
import re
import sys
from pathlib import Path
from typing import Optional, Tuple

DEFAULT_PI_CONFIG = "~/.pi/agent/models.json"
SUPPORTED_API = "openai-completions"
# A local server (Ollama/vLLM/LM Studio) usually needs no auth, but the OpenAI
# client still requires a non-empty bearer token; use a harmless placeholder.
NOAUTH_PLACEHOLDER = "pi-noauth"

_ENV_REF = re.compile(r"\$\{?(\w+)\}?\Z")


class PiConfigError(Exception):
    """Raised on any failure resolving a model from pi's models.json."""


def _config_path(config_path: Optional[os.PathLike]) -> Path:
    if config_path is not None:
        return Path(config_path)
    env = os.environ.get("UNSORRY_PI_CONFIG")
    return Path(os.path.expanduser(env or DEFAULT_PI_CONFIG))


def _expand_api_key(raw: Optional[str]) -> str:
    """Resolve an apiKey value: literal, or a `$VAR`/`${VAR}` env reference.

    Command-style keys (`!cmd`) are rejected rather than executed. A missing/empty
    key resolves to "" so the caller can substitute a placeholder.
    """
    if not raw:
        return ""
    if raw.startswith("!"):
        raise PiConfigError("command-style apiKey ('!...') is not supported")
    m = _ENV_REF.match(raw.strip())
    if m:
        var = m.group(1)
        val = os.environ.get(var)
        if not val:
            raise PiConfigError(
                f"apiKey references unset environment variable ${var}")
        return val
    return raw


def _iter_models(doc: dict):
    """Yield (provider_name, provider_obj, model_obj) for every model entry."""
    providers = doc.get("providers")
    if not isinstance(providers, dict):
        raise PiConfigError("pi config has no 'providers' object")
    for pname, prov in providers.items():
        if not isinstance(prov, dict):
            continue
        for model in prov.get("models", []) or []:
            if isinstance(model, dict) and model.get("id"):
                yield pname, prov, model


def resolve(model_name: str, config_path: Optional[os.PathLike] = None
            ) -> Tuple[str, str, str]:
    """Return (base_url, api_key, model_id) for model_name from the pi config.

    Match by model `name` first, then by `id`. The owning provider's effective api
    (model `api` override, else provider `api`) must be 'openai-completions'.
    Raises PiConfigError with an actionable message on any failure.
    """
    path = _config_path(config_path)
    try:
        doc = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError as e:
        raise PiConfigError(f"pi config not found: {path}") from e
    except (json.JSONDecodeError, OSError) as e:
        raise PiConfigError(f"pi config is not readable JSON ({path}): {e}") from e

    entries = list(_iter_models(doc))
    match = None
    # name takes priority over id (name defaults to id when absent)
    for pname, prov, model in entries:
        if model.get("name", model["id"]) == model_name:
            match = (pname, prov, model)
            break
    if match is None:
        for pname, prov, model in entries:
            if model["id"] == model_name:
                match = (pname, prov, model)
                break
    if match is None:
        raise PiConfigError(
            f"no model named '{model_name}' in {path}")

    pname, prov, model = match
    api = model.get("api", prov.get("api"))
    if api != SUPPORTED_API:
        raise PiConfigError(
            f"model '{model_name}' (provider '{pname}') has api '{api}'; "
            f"only '{SUPPORTED_API}' is supported by the OpenAI-compatible path")

    base_url = prov.get("baseUrl")
    if not base_url:
        raise PiConfigError(
            f"provider '{pname}' for model '{model_name}' has no baseUrl")

    api_key = _expand_api_key(prov.get("apiKey")) or NOAUTH_PLACEHOLDER
    return base_url, api_key, model["id"]


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    r = sub.add_parser("resolve", help="resolve a model to base_url/api_key/id")
    r.add_argument("--model", required=True, help="pi model name or id")
    r.add_argument("--config", default=None,
                   help=f"path to models.json (default: {DEFAULT_PI_CONFIG})")
    args = parser.parse_args(argv)
    try:
        base_url, api_key, model_id = resolve(args.model, config_path=args.config)
    except PiConfigError as e:
        print(f"pi_config: {e}", file=sys.stderr)
        return 1
    # Three lines, in the order agent.sh's resolve_pi_config() reads them.
    print(base_url)
    print(api_key)
    print(model_id)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
