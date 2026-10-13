# Implementation verification · October 2026

These images are renders of the implemented Flutter app. Generated concept artwork is stored separately in `../explorations/`. Screenshots use sample cases through the isolated preview entry point or the test harness; production history is never seeded.

## Next chapter and Smart gateway · 2026-10-13

The implemented followup adds interactive onboarding and practice, local Jury Duty, resumable drafts and named lineups, quick menu entry, history search/filtering, Objection recovery, PNG receipts, optional meal feedback and contextual Judge Bite reactions. Smart results use one winning-food mascot composition and a full-width ruling ticket. Lucky filing feedback appears only after a successful save; reduced motion completes immediately.

New Flutter captures include [welcome practice](welcome-demo-phone.png), [evidence](welcome-evidence-phone.png), [personality](welcome-tone-phone.png), [final offer](welcome-offer-phone.png), [Jury results](jury-results-phone.png), [successful filing](filed-verdict-phone.png), and [Spanish meal feedback at 200%](feedback-es-200.png). Receipts use actual library artwork in [English](receipt-en.png), [Spanish](receipt-es.png) and [Spanish at 200%](receipt-es-200.png). Separate `receipt-photo-fixture-*.png` captures retain the synthetic-photo framing/byte-preservation checks. [Dark-mode sharing](smart-result-dark-share.png) keeps the exported receipt cream/ink, and [Spanish sharing controls](smart-result-es-200-share-actions.png) remain reachable at large text.

The current Smart client is `AiGatewayService`; Firebase AI and initialization are removed. Versioned permission precedes real requests and can be withdrawn in Settings. Payloads contain the original case, actual optional photos and a random app UUID. Decorative art never becomes evidence. Both deployed gateway configurations require zero-data-retention providers and reasoning disabled on the primary model and both fallbacks. Model routing, privacy policy, dev/prod define files and exact request limits are documented in [the gateway contract](../../tool/gateway/README.md).

The welcome allowance remains three Smart uses; Lucky Court remains unlimited. The new platform record holds only identity and charged operation IDs, reconciled monotonically with SQLite. Apple uses Keychain and Android uses backup-eligible preferences (DataStore). Storage failure cannot grant fresh uses; retry after a committed verdict/mirror failure returns the same result. This offers local reinstall resistance, not server-authoritative lifetime entitlement. Android restore depends on OS/user backup, and loss of both stores or device reset can reset local state. SQLite and the platform mirror do not share one transaction.

Coverage is organized in [welcome/Jury flow tests](../../test/welcome_jury_flow_test.dart), [case shelf tests](../../test/case_shelf_test.dart), [verdict moments](../../test/verdict_moments_test.dart), [meal feedback persistence](../../test/meal_feedback_data_test.dart), [Smart allowance protection](../../test/smart_allowance_service_test.dart), [usage reconciliation](../../test/ai_usage_reconciliation_test.dart), [gateway adapter tests](../../test/ai_gateway_service_test.dart) and [permission tests](../../test/ai_consent_test.dart). These exercise controlled adapters, storage and HTTP responses. A final-use regression proves that a committed result can be recovered after a failed secure-storage mirror even at zero remaining uses, without another generation or charge; fresh requests remain blocked.

| Integrated check | October 13 result |
| --- | --- |
| Flutter analyzer | No issues |
| Complete Flutter suite | **284 tests passed** with preview capture enabled, concurrency 2 |
| iOS simulator build | Passed, `main_dev.dart` with private dev defines |
| Android debug APK | Passed, `main_prod.dart` with private prod defines |
| Shared Worker suite | **28 tests passed**, TypeScript check clean; Beautifully/legacy behavior covered |
| Remote configuration | Separate dev/prod configs applied and read back exactly; all three routes have reasoning disabled |
| Live dev | Valid English text verdict, 2.29 seconds |
| Live prod | Valid Spanish five-image/11-part verdict, 17.26 seconds |
| Live protections | Both environments reject missing token, outdated permission, and client output-token overrides |
| Native iPhone / iOS 26.5 | Practice reveal, evidence note, Sassy selection, final offer, two-dish menu entry, Keychain allowance preflight, permission sheet, real Smart result and PNG share-sheet export checked |
| Credential hygiene | Both routing tokens absent from tracked/non-ignored files; private config files ignored and mode 600 |

Native onboarding showed no free/Plus/pricing/quota language until the final offer. The real Smart sample used only Pizza and Tacos; it saved successfully and exported a 380 KB PNG receipt through the native share sheet. The sheet was dismissed without sending anything. Live five-image checks used bundled illustration fixtures, not personal photos, and are separate from the production rule against substituting decorative artwork for evidence. Sample timings are not performance guarantees.

Worker source is `armandojimenez/ai-gateway` commit `c77199e`, deployed version `964eae07-bfcc-465e-9678-f9905fd2e7b0`. Raw local check logs are under `/tmp/foodjury-final-*.log`; repeatable commands and the live smoke script are documented in the gateway directory. Both native builds were repeated after the final retry and localization fixes. Camera hardware, real-device reinstall/backup restoration, full VoiceOver/TalkBack and physical haptic/audio behavior still require device acceptance.

Firebase distribution was skipped as instructed when prerequisites were blocked: tester-group listing failed, Android lacks configured release signing, and no valid Apple Distribution identity is installed. See [delivery notes](../../tool/distribution/README.md). No tester release was uploaded.

Plus remains an explicitly labeled billing preview. It performs no purchase or restore and grants no verified entitlement.

## Historical redesign results · 2026-10-11 / 2026-10-12

| Check | Result |
| --- | --- |
| Flutter analyzer | No issues |
| Automated suite | 152 tests passed, including the food-menu expansion |
| iOS simulator build | Passed on Xcode 26.6 / Flutter 3.41.7 |
| Android debug APK | Passed |
| GPT-6.1 Sol, xhigh reviewer | Final Lucky Court read-only pass found no remaining blockers after fixes |
| Production asset audit | 58 images inspected; 57 cutouts have alpha, icon master is opaque |
| iPhone 17 Pro / iOS 26.5 | Native home/case rendering checked |
| iPad Pro 11-inch / iOS 26.2 | Native home, verdict, developer page and launcher icon checked |
| iPad native share sheet | Opens at the share-button anchor and dismisses without navigation changes |

The automated suite renders home, case builder, verdict, history, settings, developer profile and Design kitchen at 390×844 phone, 834×1194 tablet, 1194×834 landscape, 320×568 Spanish at 200% text scale, and phone dark mode. It also checks empty states, invalid routes and lazy 200-case history.

Behavioral tests cover 2–5 options, an explicitly selected goal, editing/removal, camera/gallery selection, replacing/removing photos, preserving notes and exact user photo bytes, saved tone/mock preference readiness, locale forwarding, AI failure, storage failure, and saving before navigation. Reveal tests cover completion, replay, leaving during animation, and enabling reduced motion during a reveal.

A [native recording of the verdict reveal](native-verdict-reveal.mp4) shows the actual animation. It is trimmed from the simulator recording and resized for sharing; the animation timing is unchanged. This capture preceded the final native status-bar contrast fix; re-recording that small system-chrome change was deferred because the Mac locked.

## Food menu expansion · 2026-10-12

24 new transparent food PNGs expand the library to 43 illustrations and 54 menu choices (41 specific foods and 13 generic categories). The [artwork board](food-library-expansion.png) displays the shipped assets. Generation prompts, style references, one mofongo refinement, source paths, and image metadata are recorded in the design manifests. Generated alpha is preserved unchanged; the audit records both raw alpha bounds and visible bounds above alpha 16 to distinguish faint edge noise from clipped food.

All 152 tests passed and the analyzer reported no issues. Seven updated library renders cover small phone, phone, 125% text, tablet, landscape, Spanish at 200% text, and dark mode. New matching tests cover dish-before-ingredient precedence, Spanish accents, whole-word boundaries, and formerly shared artwork. Existing photo/name/notes preservation and generic fallback flow tests still pass. The native simulator captures and build results below are from the preceding Lucky Court implementation; this asset expansion was checked with Flutter renders and regression tests.

## Lucky Court native verification

The feature suite adds 25 data tests and 73 UI checks: all four methods, winner-index reachability, two-contender coin guard, immutable photo/case snapshots, persisted sayings shuffle bags, migration from schema 2, three-use allowance, idempotent saves, history deletion, premium usage, concurrent Smart-request protection, malformed rankings, storage-failure retry, explicit save, identical replay, new-ID redraw, last-use confirmation, edit restoration, fresh cases and cancellation near completion.

Lucky Court layouts also cover 320×568 at 100% and 390×844 at 125% text. The reviewer caught and we fixed header/footer overflow at 200%, ignored intermediate text scaling, and narrow method-card overflow. All prior screen/flow tests continue to pass. The photo fixture in widget tests is intentionally synthetic; it validates framing and byte precedence, not physical camera quality.

[Native Lucky Court walkthrough](native-lucky-court.mp4) records the actual four animated rituals, food menu, populated case and winning-food scene on iPhone 17 Pro. The same source renders natively on iPad Pro 11-inch. Preview navigation selects fixed sample verdicts for repeatable recording; production randomness is tested separately. The clip is resized to 720px width without changing animation timing.

| New screen | Native phone | Native tablet |
| --- | --- | --- |
| Methods | [Phone](native-lucky-methods-phone.png) | [Tablet](native-lucky-methods-tablet.png) |
| Plate | [Phone](native-lucky-wheel-phone.png) | [Tablet](native-lucky-wheel-tablet.png) |
| Verdict | [Phone](native-lucky-verdict-phone.png) | [Tablet](native-lucky-lucky-tablet.png) |
| Food library | [Phone](native-lucky-library-phone.png) | [Tablet](native-lucky-library-tablet.png) |
| Ticket | [Phone](native-lucky-ticket-phone.png) | Covered by tablet render/animation checks |
| Lid | [Phone](native-lucky-cloche-phone.png) | Covered by tablet render/animation checks |
| Coin | [Phone](native-lucky-coin-phone.png) | Covered by tablet render/animation checks |

At this checkpoint, billing was a labeled price preview and onboarding integration remained pending. The October 13 implementation now includes onboarding and platform usage persistence; real purchases, verified entitlement and account-level lifetime enforcement remain documented in [DESIGN.md](../../DESIGN.md#billing-intentionally-unfinished).

## Actual app captures

| Screen | Phone | Tablet |
| --- | --- | --- |
| Home | [Phone](home-phone.png) | [Tablet](home-tablet.png) |
| Populated case | [Phone](case-populated-phone.png) | [Tablet](case-populated-tablet.png) |
| Verdict | [Phone](verdict-phone.png) | [Tablet](verdict-tablet.png) |
| Archive | [Phone](history-phone.png) | [Tablet](history-tablet.png) |
| Settings | [Phone](settings-phone.png) | [Tablet](settings-tablet.png) |
| Developer | [Phone](about-phone.png) | [Tablet](about-tablet.png) |
| Design kitchen | [Phone](kitchen-phone.png) | [Tablet](kitchen-tablet.png) |

Native captures are prefixed `native-`. Widget-test captures omit OS chrome. The test engine does not provide platform emoji fallback fonts, so some emoji appear as missing glyphs in those captures; native iOS renders them correctly (see [developer capture](native-ipad-about.png)). The portrait, illustrations, fonts and layout are bundled app assets, not screenshots embedded into the UI.

## Reproduce

```sh
flutter analyze
flutter test --dart-define=UPDATE_DESIGN_PREVIEWS=true
flutter build ios --simulator --debug --no-codesign -t lib/main_dev.dart --dart-define-from-file=config/dev.local.json
flutter build apk --debug -t lib/main_dev.dart --dart-define-from-file=config/dev.local.json
flutter run -t lib/main_preview.dart
```

The preview uses an in-memory Drift database, allowance and permission stores, and mock AI. `--dart-define=PREVIEW_ROUTE=/decision/verdict` opens the reveal. For production configuration, pair `lib/main_prod.dart` with ignored `config/prod.local.json`. Never include private configuration contents or tokens in captures or logs. Runtime tokens/components, not screenshot coordinates, implement the design. Historical build logs are local under the ignored `build/redesign-audit/` folder.

## Validation limits

The earlier redesign results are implementation and simulator checks, not store release certification. That checkpoint retained the former Firebase/Gemini service; the current gateway replaces it. Automated app flows use controlled AI/HTTP adapters and local test databases, so live model quality, gateway deployment and native reinstall/backup recovery require their own acceptance checks. Camera/gallery service selection and exact photo preservation were tested using an injected picker, not physical camera hardware. Full VoiceOver/TalkBack and device permission acceptance should be checked on physical devices before launch. No messages were sent from the recorded share-sheet checks.

## Review fixes incorporated

Busy routes exclude background pointer, keyboard and accessibility actions. Custom actions expose button semantics. Saved preferences finish loading before the first verdict request. History is lazy and thumbnails decode to bounded sizes. Photo success/removal feedback no longer places a toast over the next action. Snackbars honor reduced motion. Still loading indicators expose loading text rather than a fabricated numeric percentage. Overlapping remove controls reserve their entire 48dp hit area. Navy loading/reveal stages request light native status icons. The pizza-eating judge’s duplicate tongue was corrected, and stern/thinking/confused expressions were regenerated to be visibly distinct.
