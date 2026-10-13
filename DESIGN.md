# FoodJury design system

Version 2 · Retro Diner Courtroom · October 2026

FoodJury should feel like a warmly lit diner run by an opinionated cartoon judge: orange signage, cream menu paper, navy ink, checkerboard trim, oversized lettering, rubber-hose character art, raised buttons, and slightly crooked stamps. The approved reference is [the round-two concept](design/explorations/2026-10-11/round-2/retro-app-concept.png). Real implementation screenshots live in [design/verification](design/verification); these are distinct from the generated concept.

## Product boundaries

Preserve the food-decision flow: 2–5 contenders, optional user photos and notes, an explicit goal, the selected judge personality, AI analysis, a saved verdict, and history. User camera/gallery photos are evidence and remain visible. **App-created food imagery is illustrated in Judge Bite's style. Never add generated realistic food photographs.** Decorative food art never goes to the AI as evidence. Unknown food names get the neutral covered-dish illustration rather than a misleading guess.

## Foundations

| Role | Token | Value / use |
| --- | --- | --- |
| Orange | `AppColors.primary` | `#FF6B35`; masthead and primary actions |
| Navy | `AppColors.accent` | `#1A1A2E`; ink, outlines, hard shadows |
| Mustard | `AppColors.pop` | `#FFD23F`; hero action, selected choices, winning food |
| Cream | `AppColors.background` | `#FFF8F0`; paper and light-mode canvas |
| Dark paper | `AppColors.backgroundDark` | `#1A1A2E` |
| Dark surface | `AppColors.surfaceDark` | `#2D2D44` |
| Body ink | `ColorScheme.onSurface` | Adapts to light/dark |
| Secondary ink | `ColorScheme.onSurfaceVariant` | Dates and supporting copy |

Orange and mustard controls use navy labels, never small white text. Body text and surfaces use `ColorScheme`; the brand sign and food art keep their original colors. Dark mode changes the paper/ink system while retaining the orange masthead. Avoid generic purple Material defaults.

Display type is **Bangers**; body and utility text are **Nunito**. Fonts are bundled for offline use. The old Nunito files were HTML masquerading as TTFs; the replacement static weights are instantiated from [Google Fonts' Nunito](https://github.com/google/fonts/tree/main/ofl/nunito). Its license is bundled in `assets/fonts/Nunito-OFL.txt`. Do not substitute platform fonts or fetch fonts at runtime.

| Type role | Size |
| --- | --- |
| Main heading | 40dp; 56dp in wide compositions |
| Masthead sign | 36dp |
| Action | 25dp, uppercase Bangers |
| Section / stamp | 23dp / 25dp |
| Body / supporting | 16dp / 14dp, Nunito |
| Strong row title | 18dp, Nunito 800 |

Use live localized text for headlines, badges, decisions and buttons. Only the FoodJury wordmark is raster lettering. Never shrink important text with `FittedBox` to force a layout to fit.

## Layout and shape

`DinerTokens` is the main layout/motion contract. `AppDimensions` supplies the 4/8/16/24/32/48/64 spacing scale and shared radii. Use both instead of screen-specific numeric spacing.

| Token | Value |
| --- | --- |
| `contentWidth` | 1120dp |
| `readingWidth` | 620dp |
| `tabletBreakpoint` | 760dp of **available content width** |
| `largeTextBreakpoint` | 1.5×; switch complex compositions back to one column |
| `pageInset` / `columnGap` | 20dp / 40dp |
| `headerHeight` | Minimum 82dp, plus system safe area and trim |
| `checkerSize` | 10dp; two rows |
| `touchTarget` / `buttonHeight` | 48dp minimum / 60dp minimum |
| `sheetWidth` | 580dp maximum |
| `border` / `radius` / `shadow` | 2.5dp / 16dp / 4dp hard offset |

Portrait phones use one scrollable column. Home, case builder, verdict, settings and developer profile use balanced two-column compositions when their available width reaches 760dp and text scaling is under 1.5×. The archive stays at reading width and uses `ListView.builder`, so saved photos are mounted lazily. Landscape is supported; no portrait lock remains. Both large-text mode and short windows must remain scrollable. Sheets account for keyboard insets and safe areas.

## Composition: what makes this feel like FoodJury

1. Use an orange sign and checker trim as the stable frame.
2. Give each screen a strong headline, a useful next action, and a purposeful judge expression.
3. Layer the character, speech bubble, accent rays and action. The character's boots may cross the top edge of the action; decorative layers ignore pointers.
4. Break a ticket's border with a mascot or stamp. Keep copy and tappable targets clear; overlap the **surfaces**, not readable text.
5. Use asymmetric stars and short hand-drawn rays sparingly. One composed scene is stronger than decoration on every card.
6. Let the winning image and its celebrating judge lead the result. Use a full-width dashed ruling ticket beneath it; avoid repeating the same mascot beside the reasoning.
7. At large text sizes, simplify overlap and stack content. Accessibility is part of the composition, not a scaled-down afterthought.

## Component reference

Import `core/widgets/widgets.dart`.

| Component | Purpose |
| --- | --- |
| `DinerScaffold` | Safe-area shell, masthead, constrained body, optional Court/History navigation |
| `DinerMasthead`, `CheckerboardTrim` | Brand navigation frame; automatically grows for translations |
| `DinerHeading`, `DinerSignText`, `DinerWordmark` | Live headlines, outlined lettering, approved brand asset |
| `DinerButton` | Orange / mustard / outline native ink actions; keyboard support, button semantics, loading/disabled state |
| `DinerIconButton` | 48dp utility action with tooltip |
| `DinerChoice` | Selection with checkmark and selected semantics; wraps translated labels |
| `DinerSection` | Divider and heading; moves long auxiliary actions below at large text sizes |
| `DinerTicket` | Cream/navy outlined surface; optional hard elevation or dashed border |
| `DinerStamp` | Tilted live-text verdict badge |
| `DinerCharacterStage` | Layered judge, speech bubble, rays and optional action |
| `DinerSpeechBubble`, `DinerRays`, `DinerSunburst` | Code-drawn supporting illustration; decorative semantics excluded |
| `JudgeBite`, `JudgeBiteAnimated` | Static pose and restrained breathing/rocking version |
| `DinerFoodImage` | Real uploaded photo if present; otherwise matching decorative illustration |
| `FoodIllustration` | Transparent food art; recognized name categories with neutral fallback |
| `DinerNightSurface` | Navy loading/reveal stage with light native status and navigation icons |
| `DinerBusyBoundary` | Blocks background pointer, keyboard focus and screen-reader access during modal work |
| `DinerEntrance` | Staggered entrance with reduced-motion bypass |
| `AppDialog`, `AppBottomSheet`, `AppSnackbar` | Scrollable, localized utility surfaces in the same system |

Legacy `AppButton`, `AppSecondaryButton`, and `AppGradientButton` delegate to diner buttons. New screens should use the `Diner*` components directly. Avoid adding new uses of old standalone navigation/card examples.

### New screen recipe

```dart
DinerScaffold(
  title: context.l10n.myScreenTitle,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      DinerEntrance(child: DinerHeading(context.l10n.myHeading)),
      const SizedBox(height: AppDimensions.spaceLg),
      DinerTicket(child: Text(context.l10n.myExplanation)),
      const SizedBox(height: AppDimensions.spaceLg),
      DinerButton(label: context.l10n.myAction, onPressed: onAction),
    ],
  ),
)
```

For growing collections, use `DinerScaffold(scrollable: false, child: ListView.builder(...))`. Do not put an eager archive column inside the default scroll view. For two-column pages, decide using `LayoutBuilder.maxWidth`, not the device's marketing name.

## Character and food assets

The new production character directory is `assets/images/judge_bite_v2/`. It contains eighteen transparent poses. See [JUDGE_BITE_MASCOT_SPEC.md](JUDGE_BITE_MASCOT_SPEC.md) for anatomy, emotional direction and placement rules.

| Pose | Intended context |
| --- | --- |
| idle | Home: welcoming host |
| waving | Splash / welcome |
| thinking | Deliberation and incomplete cases; visibly concentrating, no grin |
| stern | Stern personality and opening of the verdict reveal; deadpan, furrowed brows |
| confused | Empty case / error / unexpected route; worried brows and small “o” mouth |
| excited | Case ready to submit / enthusiastic personality |
| celebrating | Verdict revealed / ruling ticket |
| sleeping | Empty archive / court recess |
| eating | Food enjoyment / design gallery; one cream mouth interior, no extra red tongue |
| pointing | Instructional illustration / design gallery |
| plate | Lucky Court host, balancing a plate with a stern expression |
| ticket | Ticket draw, holding the winning receipt |
| inspecting | Examining evidence and anticipating a ruling |
| bench | Welcoming the court and introducing a case |
| objection | Reviewing an objection or reopening a case |
| filing | Confirming a successfully saved result |
| bell | Calling attention to the next court action |
| whispering | A quiet aside or suspense before the reveal |

The About Developer poster uses `assets/images/me-diner.png`, redrawn from the original `me.png` in the judge’s illustration style. Keep the original source. The face breaks above a mustard sunburst panel, and a live localized maker stamp crosses the bottom edge. The biography, published apps and contact destinations remain real content. The [portrait prompt](design/production/developer-portrait-prompt.txt) records identity constraints.

On tablet, Home adds an illustrated House Rules ticket beneath recent cases. The pointing pose belongs to instructions; it is not a second primary action. Settings uses the same character stage with the selected personality label in its speech bubble and preview text in a dashed ticket.

Food art in `assets/images/food_illustrations/` covers pizza, tacos, burger, salad, sushi, noodles, and a neutral covered dish. Broad matches are decorative category symbols, not claims about ingredients or nutrition. User photos always take precedence. Future categories should use the same navy contour, cream highlight, orange/mustard base and restrained food-specific green.

`assets/images/brand/foodjury-wordmark.png` is transparent. `app-icon-master.png` is an opaque full-bleed square. `python3 tool/export_icons.py` exports the exact 1024px iOS universal icon and the five Android launcher densities. The OS applies the final launcher mask. Keep generated originals and prompt provenance separate from runtime exports. [Production prompts](design/production/prompts.json) document the generation and expression corrections.

## Motion contract

| Moment | Timing / behavior |
| --- | --- |
| Button press | 120ms; travels into its 4dp shadow |
| Screen content | 480ms ease-out; optional 70ms stagger per item |
| Route | 380ms ease-out fade and a small 6% translation |
| Character idle | 2600ms breathing loop; 3dp travel, gentle 0.012rad rock |
| Verdict | 1900ms: stern suspense → celebration → stamp → fade into result |
| Confetti | 1800ms finite burst; no background looping particles |
| Share / option / rankings state | Native interaction plus short switch/size transitions |

Use `reduceDinerMotion(context)` consistently. Either `disableAnimations` or `accessibleNavigation` disables entrances, route transforms, breathing, reveal, confetti, animated progress, snackbars, and haptics. Still loading indicators expose localized loading text without fabricated percentage semantics. Opening a historical verdict bypasses the reveal independently of reduced motion. Replay is an explicit action and is hidden in reduced-motion mode. Dispose every controller and timer, and respect `TickerMode` for hidden routes.

During AI work, use the route-owned `DinerDeliberation`; do not dismiss a loading state by blindly popping the navigator. `DinerBusyBoundary` keeps background actions inaccessible while busy. Save the verdict successfully before navigating and preserve entered options after a network/storage failure. Load persisted tone and dev mock settings before choosing the service and request arguments.

A successful explicit save adds a finite 740ms filing stamp. Failed writes never show it. The winner remains the visual lead on result pages and image receipts. `JudgeAside` chooses one of 55 bilingual, tone-aware contextual lines per event; parent rebuilds do not reroll it, and the saved verdict quote never changes. Sound is off by default and haptics are on; Settings controls both. Reduced motion suppresses both cues as well as visual motion.

## Accessibility and localization

- All English and Spanish UI copy belongs in the ARB files; run `flutter gen-l10n` after edits.
- Custom buttons expose button/enabled semantics; choices expose selected state. Utility actions have tooltips.
- Native ink controls support keyboard focus. Decorative overlapping artwork ignores pointers and excludes decorative semantics.
- Minimum hit areas are 48dp, even where the visible delete symbol is smaller.
- No cropped labels or fixed-height text controls at 200% scale. Keep form sheets scrollable above the keyboard.
- Body text uses navy/cream contrast. Check new color combinations instead of assuming orange text is readable on cream.
- Show real empty/loading/error states. Never seed production history with design-preview content.

## Working preview and validation

The native onboarding condenses [the approved concept](design/explorations/2026-10-11/onboarding/ONBOARDING.md) into three interactive education steps: try a practice verdict, see optional evidence, and choose Judge Bite’s personality. The practice does not create history or spend a Smart use. **Before the final offer, do not mention free access, Plus, prices, quotas or plan comparisons.** The final offer reuses the truthful price-preview screen; only verified entitlement may bypass it. Settings can replay education without selling. Preserve the existing draft when continuing into a real case. Follow the concept’s separate copy, artwork and action safe zones.

`flutter run -t lib/main_preview.dart` launches an explicitly separate offline design entry point, with in-memory sample cases, allowance and permission stores, and mock AI. It never writes real history or consumes real Smart uses. `--dart-define=PREVIEW_ROUTE=/decision/verdict` opens the reveal. Normal `main.dart` defaults to development; `main_dev.dart` and `main_prod.dart` select explicit gateway environments. Run them with the matching ignored `config/dev.local.json` or `config/prod.local.json` through `--dart-define-from-file`. Firebase initialization and its AI adapter have been removed. Configuration generation and the actual routing contract live in [tool/gateway/README.md](tool/gateway/README.md).

Settings → developer options → **Design kitchen** is the living pose/component gallery. It includes all expressions, a replayable verdict, and dialog/sheet examples. This route is for development review.

```sh
flutter analyze
flutter test
flutter test --dart-define=UPDATE_DESIGN_PREVIEWS=true
flutter build ios --simulator --debug --no-codesign
```

The responsive suite covers 390×844 phone, 834×1194 tablet, 1194×834 landscape, 320×568 Spanish at 200%, and dark mode. Behavioral tests cover case editing/limits, optional photo evidence, saved preferences, AI arguments, save ordering, recoverable errors, reveal/replay, and disposal. Inspect the generated previews as well as test results; clean layout constraints alone do not guarantee a good composition.

See the [verification record](design/verification/README.md) for concrete build/test results and the [asset manifest](design/production/asset-manifest.json) for image dimensions, alpha and checksums.

## Lucky Court and Smart rulings · native implementation

Use **Smart rulings** for Judge Bite’s reasoned decisions. The judge weighs the user’s goal, names, notes, and optional photographs. Use **Lucky Court** for the four unlimited, free rituals. Copy should sound like the court: “A little wisdom. Or a little luck.” and “Unlimited fun. Always on the house.” Explain that every contender has an equal chance; do not characterize the free experience as “no AI,” suggest its result is a nutritional/taste judgment, or present implementation jargon in product copy. The Plus price preview presents the intended unlimited Smart plan; it does not grant an entitlement. Technical service and database identifiers may still use `Ai`.

### Lettering and composition

- `DinerArcSign` paints localized Bangers lettering along a gentle arch, with navy outline and extrusion on orange mastheads. It honors the requested text scale. If the label does not fit, use wrapping live lettering; never shrink a heading to force a fit.
- `DinerPosterHeading` adds a slight tilt, curved mustard underline, and stars with reserved space. Use it for one main statement per composition, not every label. Decoration must not collide with text, photos, or touch targets.
- `DinerVoucher` is the double-bordered notched paper ticket for quotes and contender dockets. Keep its inset clear. `DinerStamp` remains the tilted case-status badge.
- `WinnerHero` gives the winning dish a large outlined mustard burst and lets the judge overlap the art’s outer margin. User photos use a tilted cream print frame, bounded decoding, and the same judge composition. The source photo takes precedence over library art in every context.
- The plate stage uses cream porcelain rims and depth, equal wedges, a fixed navy pointer, large illustrations, and a fully visible stern judge. Numbered segments map to the exact original contender order in the docket, including custom/long dish names.
- `DinerScaffold.bottomAction` keeps the main action visible in ordinary portrait layouts. At large text or under 600dp window height it joins the scroll flow. Large-text mastheads put the title below the navigation controls at full content width. Do not take the entire viewport with a header/footer.
- Minimum pair width for method cards is 304dp of available content; smaller windows use one column. Wide layouts use four methods and two-column ritual/verdict compositions. New layouts must check actual available width, localization, and text scaling.

`AppColors` adds `signHighlight`, `signShade`, `porcelainShadow`, `porcelainRim`, `sage`, `peach`, and `oat`. `CourtTokens` in `features/lucky/presentation/court_components.dart` owns stage geometry and finite ritual timing. Illustration-local proportions belong to each painter; shared spacing, typography, responsive thresholds, and colors belong to the token system.

### Motion and behavior

Each ritual has its own pace: the plate runs 3300ms, ticket 2700ms, lid 2400ms and coin 2100ms. Explicit replay and repeat draws run at 65% of their first duration. The scenes use: five plate turns with deceleration; a shaking ticket box and rising numbered receipt; a lid lift that hides the food until opening; and a four-turn coin with explicit heads/tails. The winner is selected once before animation. Skip, replay, and reduced-motion completion reveal that same result. Cancel never files a result or opens a verdict after leaving. Replay does not use another decision; draw-again creates a new unsaved case and may legitimately select the same winner.

A Lucky verdict uses a finite 1400ms celebration, an accessible result announcement, explicit durable save, replay, draw-again, sharing, original case details, and edit/alternate-method actions. Reduced motion removes transforms, loops, and haptics and goes directly to the chosen result. Test the animation’s intermediate state, completion, cancellation, and disposal, not only the final screenshot.

### Illustrated food menu

`features/food_library/data/food_catalog.dart` contains 41 specific food entries plus 13 broad categories using 43 illustrations. The expanded menu adds burritos, quesadillas, nachos, hot dogs, wings, dumplings, curry, lasagna, eggs and toast, waffles, bagels, avocado toast, fruit, ice cream, donuts, cookies, coffee, empanadas, arepas, mofongo, and tostones. Ramen, fish, and shrimp now have distinct artwork. [Generation prompts and source paths](design/food-library-prompts.json) preserve provenance; the [24-image expansion board](design/production/food-library-expansion.html) displays the actual production PNGs.

Search accepts English/Spanish labels and keywords. If there is no match, show the broad categories. Selecting a specific dish fills an empty name only. Selecting a category such as seafood preserves the user’s exact dish name and notes. The illustration ID is separate metadata, never converted into food evidence. Adding/changing art does not remove the user’s photo. Artwork travels with the frozen case through Smart rulings, Lucky draws, history, and replay.

For future menu additions, create one transparent PNG per recognizable dish in `assets/images/food_illustrations/`, with deep navy outlines, warm cel shading, and a clear three-quarter silhouette. Use the existing tacos and pasta as style references. Keep stable catalog IDs, provide both English and Spanish labels and useful search aliases, and keep generic categories separate. Add matching prompts, source paths and image metadata to the generation and production manifests. Name-based decoration uses whole food names with specific dishes before ingredients; an explicitly selected illustration always wins. Check the artwork at thumbnail size on cream and navy, plus phone, tablet and large-text layouts.

### Data and entitlement contract

- `DecisionCase` snapshots 2–5 distinct named contenders, goal, illustration IDs and photo bytes. Accepted `Verdict` snapshots are immutable; saved results never reroll or regenerate their quote.
- Random results carry method, quote ID, exact localized quote, catalog version and original contenders. They have no fabricated ranking or reasoning. The bundled 68-line EN/ES catalog uses persistent shuffle bags per tone/method/language and avoids immediate cycle-boundary repeats.
- Drift schema 3 added original contenders and random metadata, plus a separate Smart-use ledger. Successful free Smart rulings are saved and charged in one SQLite transaction. Failed AI or database saves do not spend a use; retry after a save failure reuses the cached generated result and operation ID. History deletion does not replenish uses. Verified Plus usage, when connected, must not spend remaining welcome uses.
- The allowance remains **three welcome Smart rulings**. `SmartAllowanceService` reconciles charged operation IDs from SQLite and a versioned platform record before each request and after a successful free save. The record contains a random UUID, never a hardware/advertising ID, and operation IDs only. Apple stores it in Keychain; Android uses backup-eligible preferences (DataStore). Existing pre-migration Smart verdicts remain consumed uses. Reconciliation only adds recorded uses, never subtracts them or invents history rows.
- Requests sharing the same persistent store are serialized through generation and save. A failed post-commit mirror leaves the saved result intact; retry repairs the mirror before returning that result without another generation or charge. Corrupt/unreadable state is not treated as fresh allowance: Smart shows a retry message and Lucky remains available. Preview/test databases use isolated in-memory records.
- This is reinstall resistance, not tamper-proof or account-level enforcement. Android restore depends on OS/user backup. Device reset or loss of both stores can reset local state, and the SQLite/platform mirror is not a cross-store transaction. A normal interrupted mirror reconciles on the next access while SQLite survives. Gateway request/device limits are separate from lifetime allowance; server-authoritative lifetime enforcement and verified subscription access remain launch work.

### Smart gateway, permission and evidence

`AiGatewayService` replaces Firebase AI. The client sends a single indexed food-case message and each actual photo to the configured Cloudflare gateway. It does not supply a system prompt or choose a provider model. The server-owned Judge Bite prompt, deployed dev/prod routing policy, payload limits and configuration workflow are documented in [the gateway contract](tool/gateway/README.md). That configuration requires zero-data-retention providers, denies data collection and disables reasoning. Both remote configs were independently read back and accepted live requests; see the dated verification record for evidence and limits.

Before the first real request, obtain explicit permission for the current disclosure version. The sheet names the data, recipients and random app identity; Settings can review or withdraw it. The adapter rechecks persisted permission immediately before HTTP. Missing, outdated or unreadable permission cannot imply agreement. Canceling permission retains the case and keeps Lucky available. Decorative artwork, private meal feedback and archived cases are not added to the request.

Preserve original contender IDs, names, notes and photo bytes. Reject unsupported/oversized evidence rather than silently dropping it. Accept only a complete, distinct ranking with the winner first and bounded response text; invalid responses cannot consume a local Smart use. Localized failures distinguish network/timeout, rate limits, filtered or invalid evidence, oversized cases and unavailable service configuration. Offer explicit retry, case editing or Lucky Court with the existing evidence; do not automatically reroll a saved result. Never log credentials, request bodies or photos.

### Returning diners, groups and recovery

- `CaseDraft` preserves incomplete names/options/goal locally. Draft writes are serialized, Continue waits for persistence, and a save clears only the matching case. Opening a different case asks before replacing an unfinished draft.
- Named case sets preserve exact options, optional photos, art and goal. Quick menu selection adds several contenders in one visit while respecting the 2–5 limit.
- Jury Duty is a local pass-the-phone flow for 2–5 people. Each nominates one dish and votes behind a handoff screen. Results expose totals, never voter-to-choice associations. A tie sends only leaders into Lucky Court. Nothing is submitted to AI.
- Objection offers edit, alternate method, and acceptance while preserving the saved result. Offline/timeout errors explain what happened and offer Lucky Court with the same evidence.
- Saved-case meal feedback is optional and editable: whether the winner was chosen and whether the user would order it again. History can search names/notes, filter Smart/Lucky, and show feedback.
- Receipt sharing previews the actual PNG before opening native sharing, keeps a text alternative, and anchors the share sheet on iPad. It includes the winner, quote, method, goal and contender names; private notes are omitted. User photos remain first priority.
- Drift schema 4 adds the case shelf and meal feedback. Removing history removes its feedback but retains the shelf and independent usage ledger.

### Billing intentionally unfinished

The user approved price mocks and will connect purchases later. `/plus` is explicitly a subscription preview showing **$24.99 USD/year** and **$5.99 USD/month**. Selecting a plan never charges, starts a trial, or unlocks Plus. `premiumAccessProvider` defaults to false and is an integration seam, not a trusted entitlement.

| Remaining connection | Required before selling Plus |
| --- | --- |
| Store products | Create App Store / Play products, subscription group/base plans, availability, and tax configuration. No product or entitlement IDs have been invented. |
| Purchase provider | Wire StoreKit/Play Billing or RevenueCat; use actual localized products/prices and verified entitlements. |
| Purchase lifecycle | Purchase, restore, pending/declined/cancelled states, renewal/expiry, refunds, account changes, and offline entitlement policy. |
| Lifetime Smart allowance | Authenticated server-side ledger and atomic idempotent request enforcement across installs/devices. Persistent local identity/usage and gateway rate limits do not establish trusted lifetime entitlement. |
| Store disclosures | Working terms/privacy links, renewal/cancellation disclosure, restore action, and store sandbox acceptance checks. |
| Onboarding offer | The education and final preview offer are integrated. Connect the offer to verified purchase/restore outcomes before selling; never simulate premium access. |

The [original Lucky Court concept and prototype](design/explorations/2026-10-11/random-court/LUCKY_COURT.md) are retained as design references. Actual native verification belongs in [the verification record](design/verification/README.md), not in generated mockups.
