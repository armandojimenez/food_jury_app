# Redesign verification · 2026-10-11

These images are renders of the implemented Flutter app. Generated concept artwork is stored separately in `../explorations/`. Screenshots use sample cases through the isolated preview entry point or the test harness; production history is never seeded.

## Results

| Check | Result |
| --- | --- |
| Flutter analyzer | No issues |
| Automated suite | 148 tests passed |
| iOS simulator build | Passed on Xcode 26.6 / Flutter 3.41.7 |
| Android debug APK | Passed |
| GPT-6.1 Sol, xhigh reviewer | Final Lucky Court read-only pass found no remaining blockers after fixes |
| Production asset audit | 34 images inspected; 33 cutouts have alpha, icon master is opaque |
| iPhone 17 Pro / iOS 26.5 | Native home/case rendering checked |
| iPad Pro 11-inch / iOS 26.2 | Native home, verdict, developer page and launcher icon checked |
| iPad native share sheet | Opens at the share-button anchor and dismisses without navigation changes |

The automated suite renders home, case builder, verdict, history, settings, developer profile and Design kitchen at 390×844 phone, 834×1194 tablet, 1194×834 landscape, 320×568 Spanish at 200% text scale, and phone dark mode. It also checks empty states, invalid routes and lazy 200-case history.

Behavioral tests cover 2–5 options, an explicitly selected goal, editing/removal, camera/gallery selection, replacing/removing photos, preserving notes and exact user photo bytes, saved tone/mock preference readiness, locale forwarding, AI failure, storage failure, and saving before navigation. Reveal tests cover completion, replay, leaving during animation, and enabling reduced motion during a reveal.

A [native recording of the verdict reveal](native-verdict-reveal.mp4) shows the actual animation. It is trimmed from the simulator recording and resized for sharing; the animation timing is unchanged. This capture preceded the final native status-bar contrast fix; re-recording that small system-chrome change was deferred because the Mac locked.

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

Billing is deliberately a labeled price preview, as requested. No payment or verified entitlement is implemented. True lifetime allowance across reinstalls/devices and onboarding integration remain documented in [DESIGN.md](../../DESIGN.md#billing-intentionally-unfinished).

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
flutter build ios --simulator --debug --no-codesign
flutter build apk --debug
flutter run -t lib/main_preview.dart
```

The preview uses an in-memory Drift database and mock AI. `--dart-define=PREVIEW_ROUTE=/decision/verdict` opens the reveal. Runtime tokens/components, not screenshot coordinates, implement the design. Build logs are local under the ignored `build/redesign-audit/` folder.

## Validation limits

This is an implementation and simulator check, not store release certification. The existing Firebase/Gemini service was preserved; the automated redesign flow uses a controlled AI service and local test database, so live model output was not revalidated. Camera/gallery service selection and exact photo preservation were tested using an injected picker, not physical camera hardware. Full VoiceOver/TalkBack and device permission acceptance should be checked on physical devices before launch. No messages were sent from the share sheet.

## Review fixes incorporated

Busy routes exclude background pointer, keyboard and accessibility actions. Custom actions expose button semantics. Saved preferences finish loading before the first verdict request. History is lazy and thumbnails decode to bounded sizes. Photo success/removal feedback no longer places a toast over the next action. Snackbars honor reduced motion. Still loading indicators expose loading text rather than a fabricated numeric percentage. Overlapping remove controls reserve their entire 48dp hit area. Navy loading/reveal stages request light native status icons. The pizza-eating judge’s duplicate tongue was corrected, and stern/thinking/confused expressions were regenerated to be visibly distinct.
