# Lucky Court — random rulings with Judge Bite

Design exploration · 11 October 2026 · follows the approved retro diner system in `DESIGN.md`.

The approved app redesign and onboarding concept were committed and pushed to `main` at `df64ce5e09dae110e9fa30b6c62c122f44f0ed10` before this exploration. This folder retains the approved design exploration. Lucky Court, the illustrated food library, and the local welcome allowance are now implemented in Flutter. See the current native contract and explicit billing limitations in [DESIGN.md](../../../../DESIGN.md). The prototype below is historical design evidence; its old AI labels have been superseded by **Smart rulings** in the app.

## The product decision

Every free account gets **three lifetime AI decisions**. Lucky Court is **free, unlimited, and offline**, before and after those three AI decisions are used. FoodJury Plus offers unlimited AI decisions for **$24.99 USD/year or $5.99 USD/month**. Premium members can use every Lucky method too.

The transition is a new toy, not a dead end: “Same judge. New tricks.” After the free AI allowance runs out, “Start a food case” remains the primary action. Plus is optional. Do not interrupt random draws with paywalls or ad-style interstitials.

## What to review

- `lucky-court-concept.png`: image-generated art direction; inspirational composition, not a specification of every label. Its “Elite taste approved” flourish is deliberately absent from the implemented preview: a random result makes no claim about taste or suitability.
- `prototype.html`: editable interactive source. `prepare_preview.py` bundles the fonts, raster art, and sayings into a self-contained preview below 1 MB.
- `storyboard.png`: actual rendered screen collection, separate from the generated concept.
- `lucky-court-walkthrough.mp4`: the four rituals in motion.
- `judge-sayings.json`: 44 authored lines, each available in English and Spanish. `create_sayings.py` reproduces the catalog.
- `assets/judge-plate.png`, `assets/judge-ticket.png`: new original transparent character illustrations. All app-created food art is illustrated; users can still supply their own photos.
- `prompts.json`, `asset-manifest.json`: exact built-in image-generation prompts and asset provenance.
- `verification.json`: layout, behavior, and review evidence.

The preview plays all four randomizers, edits 2–5 contenders and notes, accepts local photos, varies the judge voice, saves session history, and demonstrates free/last-credit/premium account states. The Tweak controls change account state, contender count, device layout, voice, reduced motion, and the sayings language. They are review controls, not settings to ship in the app.

AI calls and purchases are intentionally disconnected. Their buttons explain that this is a preview, without changing an allowance or charging anything. The purchase screen illustrates the offer hierarchy, not a complete StoreKit/Play Billing purchase flow. Full legal links, restore-purchase behavior, pending transactions, and store-derived localized prices belong to the approved onboarding paywall implementation.

Image bytes and session history stay in the browser and last for the preview session. Lightweight choices and the current case can be restored by the conversation host. Image bytes and session records are not saved to host state. In the native app, photos and accepted verdicts continue to use durable local storage.

## The flow

1. **Court entrance.** Show “3 of 3 free AI rulings left,” “1 of 3,” or “0 of 3”; never imply a daily refill. A Plus member sees “Unlimited AI.” The empty allowance state highlights the unlimited Lucky alternative.
2. **Build a case.** Keep the existing 2–5 options, names, optional camera/gallery photos, notes, and four goals. Do not replace user images with generated food. New decorative art is only a fallback for a matching food category; unknown foods use the neutral cloche.
3. **How shall we rule?** Separate “Ask Judge Bite · AI” from “Lucky Court · Offline.” The AI action displays the available lifetime count or the optional Plus offer. Four large illustrated method cards are easy to compare. Remember the last valid method; default to Spin the Plate. Judge personality changes banter, never odds.
4. **The ritual.** Repeat the actual contender list and the equal-chance rule. One large primary action starts the draw. Select the winner once before animation, then animate to it. “Reveal now” skips the wait. Leaving cancels presentation timers.
5. **The Lucky Verdict.** Stamp “CASE CLOSED”; show the winner, the exact method, and a locally selected judge line. Label the result “Random pick · Equal odds · No AI used.” Photos and the existing case information remain available with the record. Never show a fabricated score, ranking, health claim, or “best for your goal” badge.
6. **Close the case.** “Save & close case” explicitly accepts this random pick. This is a proposed change for Lucky mode only: intermediate rerolls do not clutter history. AI verdicts keep the existing save-before-navigation behavior. “Replay reveal” replays the same verdict; “Draw again” creates a new independent draw and may legitimately choose the same food again. A saved result is never overwritten by either action.
7. **History.** Give each row a source/method label. Reopening does not spend credits or select a new line. “Try another method” restores that record's original contenders and photo versions. A fresh case can be started separately.

The prototype has twelve captured states: exhausted entrance, case, method picker, plate, ticket, cloche, coin, Lucky verdict, saved history, last free AI confirmation, Plus offer, and new free entrance. It also contains an editable contender screen and native-layout tablet stage.

## Four methods, one fair selector

| Method | Contenders | Interaction | Character beat | Reveal |
| --- | --- | --- | --- | --- |
| Spin the Plate | 2–5 | Tap “Spin for dinner” | The stern judge supervises the oversized plate | Five turns and a deceleration into the winner's equal-size sector |
| Order Up! | 2–5 | Tap “Pull my ticket” | Judge pulls an order from a checker-trim ticket box | Rail slips swing; a tear-off ticket feeds out with the chosen number |
| Cloche Call | 2–5 | Tap “Lift the lid” | A suspicious look while the dinner cover rattles | The cover lifts and tilts away from the selected food |
| Coin Court | Exactly 2 | Tap “Flip for dinner” | The judge witnesses a classic tie breaker | A dimensional coin flips to heads or tails; mapping remains visible |

Coin Court stays visible with “Needs exactly 2 contenders” when the case contains more. Do not discard contenders to make the coin available. Editing down to two enables it. Growing a two-option case invalidates the selected coin method and falls back to the plate, visibly before starting another draw.

Each option is one entry with probability `1 / optionCount`. Goals, notes, photos, personality, payment status, tap timing, spin force, device motion, previous winners, and animation frame rate must not affect that probability. Avoid swipe-speed weighting and “pick a lucky lid” theater that suggests an untrue skill advantage.

The prototype uses `crypto.getRandomValues` with rejection sampling to remove modulo bias. Production should use `Random.secure().nextInt(n)` or an equivalently unbiased platform RNG. Select one winner index, create one immutable run, and drive all visual effects from that index. For the plate, the target rotation is `5 * 360 + 360 - (winner + 0.5) * 360 / n`, placing the chosen sector's center under the top pointer. For the coin, heads is option zero and tails option one; target rotation is `4 * 360 + winner * 180` degrees.

Do not attempt to infer the result from simulated physics. The theatrical animation presents an already selected fair result. No paid “better odds,” rewards, money stakes, or chance-linked purchases are part of this feature.

## AI allowance and entitlement contract

This is a production requirement, not implemented by the preview.

- The entitlement contains `freeAiUsed: 0...3` and verified premium status. `remaining = max(0, 3 - freeAiUsed)`. Store AI consumption independently of local history. Deleting records, reinstalling, changing the date, clearing cache, restoring a purchase, or switching random methods cannot replenish it.
- “Lifetime” needs a stable account identity and a server-owned usage ledger. The current application does not yet provide that full entitlement/identity flow. Resolve durable account restoration before shipping a lifetime promise. A local preferences counter or a resettable anonymous installation ID cannot enforce three decisions across reinstalls/devices. Offline Lucky Court must not require an account or a network connection.
- Recommendation for implementation: require a restorable account for AI entitlement, keep Lucky Court immediately usable, and explain that account restoration protects the user's three AI decisions and purchases. Identity UX is a remaining production design dependency; do not silently introduce a sign-in gate to random mode.
- Each AI request uses an idempotency key. Atomically reserve an available allowance on the server, validate the AI response, durably store the result, then commit consumption. A provider error or invalid result releases the reservation. Retry the same operation ID after a timeout. Concurrent requests cannot both use the last free decision.
- A committed AI result is retrievable even if the connection or local history write fails. Retrying must recover that same result without spending again. Cancellation before completion can release the reservation; cancellation after commit does not undo a valid result—show the recoverable ruling.
- Render the last free decision confirmation before starting: “Your last free AI ruling. After this, Lucky Court stays free and unlimited.” Primary action: “Use 1 AI decision.” Secondary: “Use a free Lucky ruling instead.”
- A random draw, animation replay, history view, or failed AI call never consumes an AI decision. The prototype's allowance scenarios are UI-only and never call Firebase.
- Premium subscription time does not consume the three free decisions. If premium expires, resume the prior unused free balance; after the balance is exhausted, Lucky Court remains available.
- When offline, present Lucky Court normally and mark AI as needing a connection. Never convert a failed AI request to random without the user choosing it. Preserve the case so switching mode is easy.

## Data model changes for native implementation

Do not put random outcomes into an AI ranking object and invent ordering for the remaining options. Introduce a result source and separate facts:

```text
DecisionRecord
  id, createdAt, caseId
  source: ai | random
  winnerOptionId
  contenderSnapshots[]: stable option ID, name, notes, immutable photo reference
  goal: existing Objective value (context only for random)
  judgeTone
  random?: method, selectedIndex, quoteId, quoteText, quoteLocale, catalogVersion
  ai?: reasoning, rankings, bonus, model/request metadata
```

Keep a random result's remaining contenders in their original case order. In history and sharing, say “Other contenders,” not “ranked second/third.” Persist the selected quote and language with the record so reopening does not rewrite the judge's words. Save immutable photo versions with the record; changing the next case's photo must not change old evidence.

The existing `Verdict` requires reasoning and ordered rankings, and Drift `Verdicts` currently uses schema version 2. Add an explicit source/method migration and backward-compatible defaults (`source=ai` for old rows), or a new common result table with safe conversion. Preserve existing AI flow tests and add meaningful random/entitlement tests. Do not retrofit random claims into `reasoning` as though they were an AI analysis.

## Offline judge copy

The versioned JSON library contains 32 general lines (eight per Stern/Sassy/Enthusiastic/Chill voice), plus three lines for each method. Each tone/method pair has 11 eligible lines. Both English and Spanish are authored; there is no translation API call. The preview can independently switch quote language to inspect both.

Use a shuffled bag per personality, method, and locale. Exhaust all eligible IDs before reshuffling. Do not immediately repeat the previous line at the bag boundary. Persist bag progress locally for the native app; changing voice uses the corresponding bag. Store the selected line in the immutable verdict. The prototype retains recent bag choices in lightweight host state, while full session state stays in memory.

All lines are generic banter. They never assert ingredients, portion size, price, travel time, nutritional value, suitability for an allergy, or an evaluation of a user photo. A repeated food winner is valid even while the banter rotates.

## Visual system and composition

Use the existing orange `#FF6B35`, navy `#1A1A2E`, mustard `#FFD23F`, cream `#FFF8F0`, Bangers display type and Nunito text. Soft green is a food-sector accent. Header/checker stripe, 2–3px navy outlines, physical paper tickets, hard shadows, and large diner props remain consistent with the main app.

New reusable components:

- **Allowance strip:** three discrete tokens plus an explicit remaining count; spent tokens are visibly crossed/completed. Plus uses an unlimited badge. The count remains legible without relying on token color.
- **Ritual tile:** one recognizable physical prop, a short method title, a one-line explanation, and a selected check. All four methods share equal visual weight. Restricted coin use states its reason.
- **Theater stage:** one visual object owns a reserved area. Mascot/artwork may cross the object's edge but must never obscure a label, pointer, input, or button. The copy region and action region stay in document flow.
- **Contender docket:** numbered rows map actual names to plate sectors/tickets. Heads/tails map explicitly to the two names. Long names wrap rather than shrinking essential text.
- **Lucky ruling ticket:** source/method, the stored local line, and the judge signature. No score or claim that this is the best option for a goal.

The generated mockup's decorative lettering and strokes are art direction. Live UI text, controls, wheel sectors, ticket values, and coin faces are implemented in code so they remain readable, localizable, accessible, and synchronized with the winner.

Phone: one vertical composition with naturally scrollable content for large type. In native implementation keep the primary action in a safe-area footer when it can do so without obscuring content; the inline preview flows naturally with the conversation rather than trapping scroll in a device frame. Tablet: put the large theater left and the heading/docket/actions right, keep comfortable reading widths, and preserve the full objects. At insufficient width, collapse to the phone flow. The Tweak device control demonstrates this split layout.

## Motion score

| Moment | Timing | Treatment |
| --- | --- | --- |
| Primary press | ~120 ms native target | Down 3px, hard shadow compresses; no animation delay before selection |
| Plate spin | 2.9 s + 0.4 s reading beat | Five turns; `cubic-bezier(.13,.7,.12,1)` deceleration; fixed pointer |
| Ticket draw | 2.7 s + 0.4 s | Slips swing five times, main ticket pulls down; selected number appears at 2.1 s |
| Cloche reveal | 2.7 s + 0.4 s | Small restrained rattle, then lid rises and tilts; no flashing |
| Coin flip | 2.7 s + 0.4 s | Vertical arc and four turns; real final heads/tails face |
| Verdict | 0.48 s | Food springs into its reserved burst, paper ticket feeds in, stamp settles with overshoot |
| Celebration | 1.4 s, once | Twelve small paper pieces; no endless confetti or idle loops |
| Reduced motion | Immediate | Show the already-selected verdict immediately; no forced delay, spin, shake, or haptics |

The native app can add gentle capped plate ticks, one ticket tear, and a soft final stamp haptic, respecting app/OS haptic settings. Audio is optional and off by default. Sound/haptics are specified, not implemented in this browser preview.

The preview uses a 260 ms short slide between screens and a single anticipatory judge nod near each reveal. Native route transitions should reuse the approved `DinerMotion` 380 ms fade/short slide; retain content hierarchy and cancel controllers on navigation. Reduced-motion changes during an in-flight draw must finish to its existing result immediately. “Replay reveal” never samples randomness or advances the quote bag.

## Accessibility and quality gates

- Announce the winner once with method and quote; do not announce every wheel tick or flying slip.
- Keep decorative illustrations hidden from accessibility. Use the live contender list as the meaningful text alternative for the physical game.
- Native controls and focus order; visible labels; selected state is more than color. After route changes, focus the main action with the current heading as its description. Preserve form edits and focus during asynchronous photo loading.
- Honor OS reduced motion at startup and mid-animation. Avoid input traps, automatic audio, and unbounded loops.
- Validate 2, 3, 4, and 5 options; impossible coin counts; duplicate food names with distinct IDs; long names/notes; cancellation/reentry; repeated winners; no-repeat bags; photo edits after a verdict; current-vs-history case snapshots; and source labels in history/share.
- Before native release, also verify VoiceOver/TalkBack, Dynamic Type up to 200%, real camera/gallery permissions, offline startup without Firebase, entitlement concurrency, restore purchases, background/resume, and physical iPhone/iPad/Android haptics. The browser prototype is not evidence that these native integrations have shipped.

## Onboarding follow-through

Update the approved onboarding free welcome to: “3 free AI rulings. Unlimited Lucky picks.” The Plus welcome remains “Unlimited AI rulings” and can mention all four Lucky methods. Add one playful story beat showing a plate spin between the AI explanation and the final offer. Do not describe free AI as daily or recurring, and do not hide the unlimited free experience behind subscription purchase.
