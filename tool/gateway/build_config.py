#!/usr/bin/env python3
"""Build reviewable FoodJury configs; optionally create ignored unique tokens.

Mirrors Beautifully's verified model order and host/privacy policy. This script
is local only. It never reads provider credentials or changes Cloudflare.
"""
import argparse
import json
import os
from pathlib import Path
import secrets

ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
GATEWAY = "https://ai-gateway.armando-rsx.workers.dev"
CONSENT_VERSION = "foodjury-ai-v1-2026-10-13"


def provider(model, hosts):
    return {
        "provider": "openrouter", "base_url": "https://openrouter.ai/api/v1",
        "model": model, "max_tokens": 700,
        "extra_params": {
            "reasoning": {"enabled": False},
            "provider": {"zdr": True, "data_collection": "deny", "only": hosts,
                         "allow_fallbacks": False, "require_parameters": True,
                         "sort": "latency"},
        },
    }


def make_config(token):
    schema = {
        "type": "object", "additionalProperties": False,
        "properties": {
            "winner": {"type": "integer", "minimum": 1, "maximum": 5},
            "rankings": {"type": "array", "minItems": 2, "maxItems": 5,
                         "items": {"type": "integer", "minimum": 1, "maximum": 5}},
            "verdict": {"type": "string", "minLength": 1, "maxLength": 700},
            "bonus_type": {"type": "string", "enum": ["joke", "fun_fact", "tip", "story"]},
            "bonus": {"type": "string", "minLength": 1, "maxLength": 250},
        },
        "required": ["winner", "rankings", "verdict", "bonus_type", "bonus"],
    }
    return {
        "auth_token": token,
        "primary": provider("openai/gpt-6-luna", ["azure"]),
        "fallback_chain": [
            provider("~openai/gpt-luna-latest", ["openai", "azure"]),
            provider("deepseek/deepseek-v4.1-flash", ["baseten"]),
        ],
        "system_prompts": {"verdict": (HERE / "prompts/verdict.txt").read_text()},
        "response_contracts": {"verdict": {
            "kind": "verdict",
            "max_characters": 1600,
            "json_required_keys": schema["required"],
        }},
        "response_formats": {"verdict": {"type": "json_schema", "json_schema": {
            "name": "foodjury_verdict", "strict": True, "schema": schema,
        }}},
        "images": {"max_count": 5, "max_bytes": 1500000,
                   "mime": ["image/jpeg", "image/png", "image/webp", "image/gif"]},
        "consent_version": CONSENT_VERSION,
        "allowed_locales": ["en", "es"], "strict_user_only": True,
        "max_input_characters": 12000, "max_request_bytes": 11000000,
        "max_tokens_ceiling": 700, "provider_timeout_ms": 10000,
        "reservation_slack_ms": 22000, "redact_provider_metadata": True,
        "device_rate_limit": {"per_minute": 10, "per_day": 100, "per_hour": 20,
                              "cooldown_seconds": 3, "one_in_flight": True},
    }


def private_json(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    with os.fdopen(os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600), "w") as out:
        json.dump(data, out, ensure_ascii=False, indent=2)
        out.write("\n")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--create", choices=["dev", "prod"],
                        help="Create new ignored mode-600 files; never overwrite credentials")
    args = parser.parse_args()
    for env in ["dev", "prod"]:
        path = HERE / f"foodjury.{env}.example.json"
        path.write_text(json.dumps(make_config(f"<unique FoodJury {env} token>"),
                                   ensure_ascii=False, indent=2) + "\n")
    if args.create:
        token = secrets.token_hex(32)
        remote = ROOT / ".local/gateway" / f"foodjury.{args.create}.json"
        defines = ROOT / "config" / f"{args.create}.local.json"
        # Check both first, so a normal rerun cannot leave mismatched pairs.
        if remote.exists() or defines.exists():
            parser.error("Credential files already exist; inspect and preserve them.")
        private_json(remote, make_config(token))
        private_json(defines, {"AI_GATEWAY_TOKEN": token, "AI_GATEWAY_URL": GATEWAY})
        print(f"Created private {args.create} config and build defines. No remote write.")
    print("Updated redacted dev/prod review configurations.")


if __name__ == "__main__":
    main()
