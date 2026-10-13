#!/usr/bin/env python3
"""Explicit live acceptance check. Sends only bundled, synthetic food fixtures.

One accepted model request per invocation; also checks three rejected requests.
Credentials are read from ignored build defines and never printed. The photo
mode intentionally uses illustration fixtures to test transport/vision decoding;
the production client never substitutes library artwork for a user's photo.
"""
import argparse
import base64
import json
from pathlib import Path
import time
import urllib.error
import urllib.request
import uuid

ROOT = Path(__file__).resolve().parents[2]
CONSENT = "foodjury-ai-v1-2026-10-13"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--env", choices=["dev", "prod"], required=True)
    parser.add_argument("--photos", action="store_true")
    args = parser.parse_args()
    config = json.loads((ROOT / f"config/{args.env}.local.json").read_text())
    options = [
        {"index": 1, "name": "Tacos", "notes": "Ready in 5 minutes", "photo": args.photos},
        {"index": 2, "name": "Pizza", "notes": "Ready in 20 minutes", "photo": args.photos},
    ]
    names = ["tacos", "pizza"]
    if args.photos:
        names += ["salad", "burger", "soup"]
        for index, name in enumerate(names[2:], 3):
            options.append({"index": index, "name": name, "notes": "QA illustration fixture", "photo": True})
    content = [{"type": "text", "text": json.dumps({
        "v": 1, "task": "verdict", "objective": "quick", "tone": "sassy", "options": options,
    })}]
    if args.photos:
        for index, name in enumerate(names, 1):
            raw = (ROOT / f"assets/images/food_illustrations/{name}.png").read_bytes()
            assert len(raw) <= 1500000
            content += [
                {"type": "text", "text": json.dumps({"photo_for_option": index})},
                {"type": "image_url", "image_url": {"url": "data:image/png;base64," + base64.b64encode(raw).decode()}},
            ]
    body = {"messages": [{"role": "user", "content": content}]}
    headers = {
        "User-Agent": "FoodJuryGatewayQA/1.0",
        "Content-Type": "application/json", "Authorization": "Bearer " + config["AI_GATEWAY_TOKEN"],
        "x-app-id": "foodjury", "x-env": args.env, "x-task": "verdict",
        "x-locale": "es" if args.photos else "en", "x-device-id": str(uuid.uuid4()),
        "x-consent-version": CONSENT,
    }

    def send(payload, request_headers):
        request = urllib.request.Request(config["AI_GATEWAY_URL"] + "/v1/chat",
                                         data=json.dumps(payload).encode(), headers=request_headers)
        try:
            with urllib.request.urlopen(request, timeout=45) as response:
                return response.status, json.load(response)
        except urllib.error.HTTPError as error:
            try:
                return error.code, json.load(error)
            except ValueError:
                return error.code, {"error": "non_json_response"}

    rejected = []
    # Rejection checks do not need to upload image bytes to an early-exit route.
    text_case = {"messages": [{"role": "user", "content": [content[0]]}]}
    for name, request_headers, payload, expected in [
        ("missing_token", {k: v for k, v in headers.items() if k != "Authorization"}, text_case, 401),
        ("outdated_consent", {**headers, "x-consent-version": "outdated-qa"}, text_case, 412),
        ("client_generation_override", headers, {**text_case, "max_tokens": 999999}, 400),
    ]:
        status, _ = send(payload, request_headers)
        assert status == expected, f"{name}: HTTP {status}, expected {expected}"
        rejected.append({"check": name, "status": status})
    started = time.monotonic()
    status, response = send(body, headers)
    elapsed = round(time.monotonic() - started, 2)
    if status != 200:
        raise RuntimeError(f"{args.env}: HTTP {status}; code={response.get('error', 'unknown')}")
    assert set(response) == {"text"}, "Provider metadata should remain redacted"
    verdict = json.loads(response["text"])
    assert set(verdict) == {"winner", "rankings", "verdict", "bonus_type", "bonus"}
    assert type(verdict["winner"]) is int and all(type(i) is int for i in verdict["rankings"])
    assert sorted(verdict["rankings"]) == list(range(1, len(options) + 1))
    assert verdict["rankings"][0] == verdict["winner"]
    assert isinstance(verdict["verdict"], str) and 0 < len(verdict["verdict"].strip()) <= 700
    assert isinstance(verdict["bonus"], str) and 0 < len(verdict["bonus"].strip()) <= 250
    assert verdict["bonus_type"] in ["joke", "fun_fact", "tip", "story"]
    print(json.dumps({"environment": args.env, "status": status, "seconds": elapsed,
                      "photo_count": len(names) if args.photos else 0, "parts": len(content),
                      "rejected_requests": rejected, "verdict": verdict}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
