"""Hermetic tests for the pi-coder models.json resolver (ADR-025).

No network, no real ~/.pi: every test writes a temp models.json and resolves
against it. Pins the (base_url, api_key, model_id) contract that agent.sh's
`-pi` handler depends on.
"""
import json
import subprocess
import sys
from pathlib import Path

import pytest

from tools.llm_providers.pi_config import PiConfigError, resolve


def write_cfg(tmp_path: Path, cfg: dict) -> Path:
    p = tmp_path / "models.json"
    p.write_text(json.dumps(cfg), encoding="utf-8")
    return p


OLLAMA = {
    "providers": {
        "ollama": {
            "baseUrl": "http://localhost:11434/v1",
            "api": "openai-completions",
            "apiKey": "ollama",
            "models": [{"id": "llama3.1:8b", "name": "Llama 3.1 8B (Local)"}],
        }
    }
}


def test_resolve_happy_by_name(tmp_path):
    cfg = write_cfg(tmp_path, OLLAMA)
    assert resolve("Llama 3.1 8B (Local)", config_path=cfg) == (
        "http://localhost:11434/v1",
        "ollama",
        "llama3.1:8b",
    )


def test_resolve_fallback_by_id(tmp_path):
    cfg = write_cfg(tmp_path, OLLAMA)
    # name search misses, id search hits — same triple
    assert resolve("llama3.1:8b", config_path=cfg) == (
        "http://localhost:11434/v1",
        "ollama",
        "llama3.1:8b",
    )


def test_name_takes_priority_over_id(tmp_path):
    # A model whose `name` equals another model's `id` must match by name first.
    cfg = write_cfg(tmp_path, {
        "providers": {
            "p": {
                "baseUrl": "http://h/v1", "api": "openai-completions", "apiKey": "k",
                "models": [
                    {"id": "alpha", "name": "shared"},
                    {"id": "shared", "name": "beta"},
                ],
            }
        }
    })
    # "shared" matches the first model by name, returning its id "alpha"
    assert resolve("shared", config_path=cfg)[2] == "alpha"


def test_env_apikey_expansion(tmp_path, monkeypatch):
    monkeypatch.setenv("OLLAMA_KEY", "secret-123")
    for raw in ("$OLLAMA_KEY", "${OLLAMA_KEY}"):
        cfg = write_cfg(tmp_path, {
            "providers": {"p": {
                "baseUrl": "http://h/v1", "api": "openai-completions", "apiKey": raw,
                "models": [{"id": "m"}]}}})
        assert resolve("m", config_path=cfg)[1] == "secret-123"


def test_literal_apikey_unchanged(tmp_path):
    cfg = write_cfg(tmp_path, OLLAMA)
    assert resolve("llama3.1:8b", config_path=cfg)[1] == "ollama"


def test_missing_apikey_gets_placeholder(tmp_path):
    # A local server needs no auth; the OpenAI client still requires a non-empty
    # key, so a missing apiKey resolves to a harmless placeholder (not "").
    cfg = write_cfg(tmp_path, {
        "providers": {"p": {
            "baseUrl": "http://h/v1", "api": "openai-completions",
            "models": [{"id": "m"}]}}})
    key = resolve("m", config_path=cfg)[1]
    assert key  # non-empty


def test_missing_file_names_path(tmp_path):
    missing = tmp_path / "nope.json"
    with pytest.raises(PiConfigError) as e:
        resolve("m", config_path=missing)
    assert str(missing) in str(e.value)


def test_missing_model(tmp_path):
    cfg = write_cfg(tmp_path, OLLAMA)
    with pytest.raises(PiConfigError) as e:
        resolve("does-not-exist", config_path=cfg)
    assert "does-not-exist" in str(e.value)


def test_non_openai_api_type(tmp_path):
    cfg = write_cfg(tmp_path, {
        "providers": {"anthropic": {
            "baseUrl": "http://h", "api": "anthropic-messages", "apiKey": "k",
            "models": [{"id": "claude-x", "name": "Claude X"}]}}})
    with pytest.raises(PiConfigError) as e:
        resolve("Claude X", config_path=cfg)
    assert "openai-completions" in str(e.value)


def test_model_level_api_override(tmp_path):
    # provider api is openai-completions, but the matched model overrides it.
    cfg = write_cfg(tmp_path, {
        "providers": {"p": {
            "baseUrl": "http://h", "api": "openai-completions", "apiKey": "k",
            "models": [{"id": "m", "api": "google-generative-ai"}]}}})
    with pytest.raises(PiConfigError):
        resolve("m", config_path=cfg)


def test_unresolved_env_apikey(tmp_path, monkeypatch):
    monkeypatch.delenv("MISSING_KEY", raising=False)
    cfg = write_cfg(tmp_path, {
        "providers": {"p": {
            "baseUrl": "http://h/v1", "api": "openai-completions", "apiKey": "$MISSING_KEY",
            "models": [{"id": "m"}]}}})
    with pytest.raises(PiConfigError) as e:
        resolve("m", config_path=cfg)
    assert "MISSING_KEY" in str(e.value)


def test_command_apikey_rejected(tmp_path):
    cfg = write_cfg(tmp_path, {
        "providers": {"p": {
            "baseUrl": "http://h/v1", "api": "openai-completions", "apiKey": "!cat /etc/passwd",
            "models": [{"id": "m"}]}}})
    with pytest.raises(PiConfigError):
        resolve("m", config_path=cfg)


def test_malformed_json(tmp_path):
    p = tmp_path / "models.json"
    p.write_text("{ this is not json", encoding="utf-8")
    with pytest.raises(PiConfigError):
        resolve("m", config_path=p)


def test_multi_provider_ownership(tmp_path):
    # The matched model's OWN provider's baseUrl/apiKey must be returned.
    cfg = write_cfg(tmp_path, {
        "providers": {
            "a": {"baseUrl": "http://a/v1", "api": "openai-completions", "apiKey": "ka",
                  "models": [{"id": "ma"}]},
            "b": {"baseUrl": "http://b/v1", "api": "openai-completions", "apiKey": "kb",
                  "models": [{"id": "mb"}]},
        }})
    assert resolve("mb", config_path=cfg) == ("http://b/v1", "kb", "mb")


def test_cli_three_line_contract(tmp_path):
    cfg = write_cfg(tmp_path, OLLAMA)
    out = subprocess.run(
        [sys.executable, "-m", "tools.llm_providers.pi_config",
         "resolve", "--model", "llama3.1:8b", "--config", str(cfg)],
        capture_output=True, text=True, cwd=Path(__file__).resolve().parents[3])
    assert out.returncode == 0, out.stderr
    assert out.stdout.splitlines() == ["http://localhost:11434/v1", "ollama", "llama3.1:8b"]


def test_cli_error_exits_nonzero(tmp_path):
    cfg = write_cfg(tmp_path, OLLAMA)
    out = subprocess.run(
        [sys.executable, "-m", "tools.llm_providers.pi_config",
         "resolve", "--model", "nope", "--config", str(cfg)],
        capture_output=True, text=True, cwd=Path(__file__).resolve().parents[3])
    assert out.returncode != 0
    assert out.stderr.strip()
