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
6. Let the approval stamp sit across the winning image's lower edge. Use a dashed ruling ticket with the celebrating judge emerging from its upper-left edge.
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

The new production character directory is `assets/images/judge_bite_v2/`. It contains twelve transparent full-body poses. See [JUDGE_BITE_MASCOT_SPEC.md](JUDGE_BITE_MASCOT_SPEC.md) for anatomy, emotional direction and placement rules.

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

## Accessibility and localization

- All English and Spanish UI copy belongs in the ARB files; run `flutter gen-l10n` after edits.
- Custom buttons expose button/enabled semantics; choices expose selected state. Utility actions have tooltips.
- Native ink controls support keyboard focus. Decorative overlapping artwork ignores pointers and excludes decorative semantics.
- Minimum hit areas are 48dp, even where the visible delete symbol is smaller.
- No cropped labels or fixed-height text controls at 200% scale. Keep form sheets scrollable above the keyboard.
- Body text uses navy/cream contrast. Check new color combinations instead of assuming orange text is readable on cream.
- Show real empty/loading/error states. Never seed production history with design-preview content.

## Working preview and validation

The proposed onboarding experience is documented in [Your first case at the food court](design/explorations/2026-10-11/onboarding/ONBOARDING.md). Its animated concept covers seven educational steps, a Plus offer, and separate free/Plus welcomes. It is a design prototype, not an integrated Flutter or billing flow. Follow its copy/art/action safe zones when extending layered compositions.

`flutter run -t lib/main_preview.dart` launches an explicitly separate offline design entry point, with in-memory sample cases and mock AI. It does not initialize Firebase or modify the real history database. `--dart-define=PREVIEW_ROUTE=/decision/verdict` opens the reveal. Normal `main.dart`, `main_dev.dart`, and `main_prod.dart` retain the existing production flow.

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

Use **Smart rulings** for Judge Bite’s reasoned decisions. The judge weighs the user’s goal, names, notes, and optional photographs. Use **Lucky Court** for the four free rituals. Copy should sound like the court: “A little wisdom. Or a little luck.” and “Unlimited fun. Always on the house.” Explain that every contender has an equal chance; do not characterize the free experience as “no AI,” suggest its result is a nutritional/taste judgment, or present implementation jargon in product copy. Plus offers unlimited Smart rulings. Technical service and database identifiers may still use `Ai`.

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

The four rituals run for 3300ms: five plate turns with deceleration; a shaking ticket box and rising numbered receipt; a lid lift that hides the food until opening; and a four-turn coin with explicit heads/tails. The winner is selected once before animation. Skip, replay, and reduced-motion completion reveal that same result. Cancel never files a result or opens a verdict after leaving. Replay does not use another decision; draw-again creates a new unsaved case and may legitimately select the same winner.

A Lucky verdict uses a finite 1400ms celebration, an accessible result announcement, explicit durable save, replay, draw-again, sharing, original case details, and edit/alternate-method actions. Reduced motion removes transforms, loops, and haptics and goes directly to the chosen result. Test the animation’s intermediate state, completion, cancellation, and disposal, not only the final screenshot.

### Illustrated food menu

`features/food_library/data/food_catalog.dart` contains 41 specific food entries plus 13 broad categories using 43 illustrations. The expanded menu adds burritos, quesadillas, nachos, hot dogs, wings, dumplings, curry, lasagna, eggs and toast, waffles, bagels, avocado toast, fruit, ice cream, donuts, cookies, coffee, empanadas, arepas, mofongo, and tostones. Ramen, fish, and shrimp now have distinct artwork. [Generation prompts and source paths](design/food-library-prompts.json) preserve provenance; the [24-image expansion board](design/production/food-library-expansion.html) displays the actual production PNGs.

Search accepts English/Spanish labels and keywords. If there is no match, show the broad categories. Selecting a specific dish fills an empty name only. Selecting a category such as seafood preserves the user’s exact dish name and notes. The illustration ID is separate metadata, never converted into food evidence. Adding/changing art does not remove the user’s photo. Artwork travels with the frozen case through Smart rulings, Lucky draws, history, and replay.

For future menu additions, create one transparent PNG per recognizable dish in `assets/images/food_illustrations/`, with deep navy outlines, warm cel shading, and a clear three-quarter silhouette. Use the existing tacos and pasta as style references. Keep stable catalog IDs, provide both English and Spanish labels and useful search aliases, and keep generic categories separate. Add matching prompts, source paths and image metadata to the generation and production manifests. Name-based decoration uses whole food names with specific dishes before ingredients; an explicitly selected illustration always wins. Check the artwork at thumbnail size on cream and navy, plus phone, tablet and large-text layouts.

### Data and entitlement contract

- `DecisionCase` snapshots 2–5 distinct named contenders, goal, illustration IDs and photo bytes. Accepted `Verdict` snapshots are immutable; saved results never reroll or regenerate their quote.
- Random results carry method, quote ID, exact localized quote, catalog version and original contenders. They have no fabricated ranking or reasoning. The bundled 44-line EN/ES catalog uses persistent shuffle bags per tone/method/language and avoids immediate cycle-boundary repeats.
- Drift schema 3 adds original contenders and random metadata, plus a separate Smart-use ledger. Successful free Smart rulings are saved and charged atomically. Failed/cancelled requests do not spend a use; retry after a save failure reuses the cached generated result and operation ID. History deletion does not replenish uses. Plus usage does not spend remaining welcome uses.
- Three welcome Smart rulings are enforced **per local installation** today. Existing pre-migration Smart verdicts are backfilled as consumed uses. True lifetime enforcement across reinstalls/devices needs an authenticated account and server ledger before launch.

### Billing intentionally unfinished

The user approved price mocks and will connect purchases later. `/plus` is explicitly a subscription preview showing **$24.99 USD/year** and **$5.99 USD/month**. Selecting a plan never charges, starts a trial, or unlocks Plus. `premiumAccessProvider` defaults to false and is an integration seam, not a trusted entitlement.

| Remaining connection | Required before selling Plus |
| --- | --- |
| Store products | Create App Store / Play products, subscription group/base plans, availability, and tax configuration. No product or entitlement IDs have been invented. |
| Purchase provider | Wire StoreKit/Play Billing or RevenueCat; use actual localized products/prices and verified entitlements. |
| Purchase lifecycle | Purchase, restore, pending/declined/cancelled states, renewal/expiry, refunds, account changes, and offline entitlement policy. |
| Lifetime Smart allowance | Authenticated server-side ledger and atomic idempotent request enforcement across installs/devices. The local ledger is not abuse protection. |
| Store disclosures | Working terms/privacy links, renewal/cancellation disclosure, restore action, and store sandbox acceptance checks. |
| Onboarding | The approved onboarding remains a separate design prototype; its educational flow and premium/free welcome are not integrated into Flutter yet. |

The [original Lucky Court concept and prototype](design/explorations/2026-10-11/random-court/LUCKY_COURT.md) are retained as design references. Actual native verification belongs in [the verification record](design/verification/README.md), not in generated mockups.
