# FoodJury AI Gateway

FoodJury sends Smart cases through the owner's Cloudflare Worker at
`https://ai-gateway.armando-rsx.workers.dev/v1/chat`. Lucky Court and onboarding
practice stay local. Firebase AI and Firebase initialization have been removed.

## Models and privacy policy

The routing matches Beautifully's live `beautifully:dev` configuration read on
October 13, 2026, and its repository at `75fdbf6`:

| Order | Model | Allowed hosts |
| --- | --- | --- |
| Primary | `openai/gpt-6-luna` | Azure |
| Fallback 1 | `~openai/gpt-luna-latest` | OpenAI, Azure |
| Fallback 2 | `deepseek/deepseek-v4.1-flash` | BaseTen |

**Every provider explicitly sets `reasoning.enabled: false`.** All routes require
OpenRouter zero-data-retention providers, deny data collection, pin the listed
hosts, and disable fallbacks to unlisted hosts. FoodJury uses its own tokens and
Judge Bite prompt; no Beautifully/Unworried credentials or personal-photo prompts
are reused. The routing token embedded in an app is not a provider API secret or
proof of a trusted device; the gateway also enforces request and device limits.

[`prompts/verdict.txt`](prompts/verdict.txt) is the server-owned prompt. It accepts
only a food case, treats names/notes/photo text as evidence, grounds the verdict,
and prevents invented nutrition, safety, timing or allergen claims. The client
sends no system prompt, model, output-token override or response schema.

## Photo and response contract

One user message contains a JSON case (`v`, `task`, `objective`, `tone`, `options`)
followed by each actual photo. A `photo_for_option` text part immediately precedes
its image part and names the original 1-based index. Decorative food art never
enters this payload. Names, notes and original photo bytes are retained unchanged.

The app and config allow 2–5 contenders, at most five photos, 1,500,000 decoded
bytes per image, JPEG/PNG/WebP/GIF, 12,000 text characters and 11,000,000 request
bytes. Unsupported or oversized photos produce an actionable failure; none are
silently omitted. Five indexed photos require 11 message parts.

The server requests strict JSON with `winner`, `rankings`, `verdict`, `bonus_type`
and `bonus`. Its scoped `kind: verdict` contract validates the exact keys, every
original contender exactly once, the winner first, valid indices, bounded text
and a recognized bonus type. Invalid output advances to the next configured
provider. The client checks the same invariants independently. Invalid responses
spend no local Smart use.

Versioned permission (`foodjury-ai-v1-2026-10-13`) is accepted before the first
real Smart request and can be withdrawn in Settings. Both the client and gateway
check its version. Headers include the explicit environment, locale, task and
random app installation ID. This ID is not a hardware or advertising identifier.

The three provider attempts each have a 10-second deadline, with a 32-second
reservation. The client aborts at 40 seconds. Device guardrails match Beautifully:
100 successful responses/day, 20/hour, 3-second cooldown and one in flight, plus
shared minute rate limiters. These guardrails are separate from the three local
welcome Smart uses. A provider moderation block is terminal, not bypassed by a
fallback. No request body or credential is logged by the client.

## Local build configuration

`build_config.py` regenerates redacted, reviewable dev/prod JSON. Optional
`--create dev` / `--create prod` creates separate random credentials with mode 600
and refuses to overwrite existing files. It never writes to Cloudflare.

Private Worker config files live under ignored `.local/gateway/`. Ignored
`config/dev.local.json` and `config/prod.local.json` contain matching dart-defines.
Use the matching entrypoint and define file:

```sh
flutter run -t lib/main_dev.dart --dart-define-from-file=config/dev.local.json
flutter run -t lib/main_prod.dart --dart-define-from-file=config/prod.local.json
flutter run -t lib/main_preview.dart
```

Provider API keys stay in the shared Worker's existing secrets. Do not put tokens
in launch arguments, commits, screenshots, issue descriptions or test logs.

## Deployed acceptance check · October 13, 2026

Worker source: `armandojimenez/ai-gateway`, commit `c77199e`. Deployed version:
`964eae07-bfcc-465e-9678-f9905fd2e7b0`. The preceding version was
`795fb755-5057-4bc2-a4e2-f9f581d15249`. Both `foodjury:dev` and `foodjury:prod`
were written and independently read back with exact config equality, distinct
credentials and reasoning disabled on all three routes. Existing app configs
and provider secrets were not changed.

All 28 gateway tests and TypeScript checks passed, including Beautifully/legacy
regressions, five indexed mixed-format images and malformed-primary fallback.
Live development returned a valid English text verdict in 2.29 seconds. Live
production returned a valid Spanish five-image verdict (11 parts) in 17.26
seconds. Both checks chose the five-minute tacos over twenty-minute pizza using
the supplied notes. These are two samples, not a latency or quality guarantee.

Both environments rejected a missing token (401), outdated permission (412), and
a client output-token override (400). Response metadata stayed redacted. To run
another explicit check, which makes one accepted model request per invocation:

```sh
python3 tool/gateway/smoke_test.py --env dev
python3 tool/gateway/smoke_test.py --env prod --photos
```

The photo check uses bundled illustrations as declared QA fixtures only; no
personal photos are uploaded. This exercises real image transport and decoding,
while normal application requests continue to send only user-attached photos.

## Usage persistence

The pattern follows Unworried at `2196a56`: Apple Keychain, and Android's
backup-eligible preferences (DataStore). FoodJury stores a random UUID and only
charged operation IDs. It monotonically reconciles this record with SQLite
before each request and after a successful save. Failed AI/DB writes do not
spend a use. A failed mirror retries the same committed result without another
generation or charge. History deletion does not refund uses. Corrupt or
unreadable storage blocks Smart safely while Lucky stays available.

This is reinstall resistance, not tamper-proof entitlement or lifetime server
enforcement. Android restore depends on OS/user backup; a device reset or loss of
both stores can reset local state. SQLite and Keychain/preferences cannot commit
atomically, so normal interrupted mirrors reconcile on the next launch while
the DB exists. Tests/preview use independent in-memory stores. Real subscription
verification and server-authoritative lifetime enforcement remain launch work.
