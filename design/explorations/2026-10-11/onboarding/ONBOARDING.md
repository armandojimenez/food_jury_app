# Your first case at the food court

FoodJury onboarding concept · October 11, 2026

This is a reviewable design and animated interaction prototype. It does not change the Flutter app, initialize billing, collect evidence, or call AI. The existing case builder, camera/gallery, photos, notes, goals, personalities, saved verdicts and history remain intact.

## The experience

Seven story steps lead into one membership offer and a welcome selected by entitlement. Back and Skip are available throughout education. Skip goes to the offer; Continue with free access goes to the free welcome. No slide auto-advances while someone is reading. Only the explicitly triggered hearing moves automatically into its result.

| Step | Screen | What the user learns or does | Character / motion |
| --- | --- | --- | --- |
| 1 | Dinner's on trial | FoodJury is an AI judge for deciding what to eat | Stern Judge Bite arrives at a diner bench. Food contender cards land behind him. “You choose” is overruled. |
| 2 | Call your contenders | Add 2–5 food choices | Three illustrated evidence cards arrive in sequence. Food names stay above the overlapping image regions. |
| 3 | Got evidence? Let's see it | Names are enough; their own photos and notes are optional context | A new magnifying-glass pose inspects an illustrated photo card. Photo/Note examples change the attached note. |
| 4 | State your cravings | Pick Fun, Healthy, Fit or Quick | Stern crossed-arm pose. “Anything” is not an answer. Goal selection changes the example verdict. |
| 5 | A little sass? Or all business? | Pick Stern, Sassy, Enthusiastic or Chill | The pose, expression and line change immediately. The tone choice remains selected through the sequence. |
| 6 | Order in the food court | Judge Bite weighs their options, goal and context | Call for a verdict starts the spotlight, food motion and gavel-character recoil sequence. No fabricated percentage. |
| 7 | Case closed. Craving solved. | They receive a winner and reasons, with saved results | A ruling ticket feeds in, the judge celebrates, APPROVED stamps down, and a finite confetti burst completes the reveal. Replay is explicit. |
| Offer | Less “you choose.” More let's eat. | Plus adds unlimited decisions | A diner membership ticket shares a scene with the pointing judge. Plan prices and shared core features remain separate. |
| Plus welcome | The court is yours | Unlimited access is active | Orange celebration, member stamp, short confetti burst. Open my first case continues. |
| Free welcome | You're in. Court's open. | They are welcome to start free | Cream welcome with waving judge. Photos, notes, goals and saved verdicts remain part of the app. |

Seven education pages do not require seven form submissions: the evidence and personality interactions are previews, goal is preselected for the demo, and every step is skippable. The final implementation can retain optional chosen preferences without creating a real case or adding demo history.

## Composition and safe zones

Use the existing [design system](../../../../DESIGN.md): Bangers, Nunito, orange `#FF6B35`, navy `#1A1A2E`, cream `#FFF8F0`, mustard `#FFD23F`, hard shadows and checker trim. The prototype embeds the existing fonts and uses live text for all UI except the approved wordmark.

Each page has three independent regions: copy, illustration, and actions. Use the illustration region for overlapping surfaces; keep headline, food names, prices, benefits and controls clear. A mascot may cross a ticket's empty edge, never its explanation. Rotated paper needs enough space for its transformed bounds, not just its unrotated rectangle.

- Keep approximately 20–24 logical pixels of page inset and a 48-pixel preferred hit area; the concept's small secondary controls are at least 44 pixels high.
- Main headlines: 44 Bangers, approximately 1.0 line height. Long paywall copy uses 38; narrow layouts use 34–39. Body: 15 Nunito, 1.45 line height. Action: 25 Bangers.
- Three evidence cards use food titles at the top and food art beneath. The removed lower exhibit labels must not return underneath the foreground card.
- The membership illustration owns its full height in normal flow. Rotation and the torn edge are contained within that region. Benefits start after the illustration, never beneath it.
- The bench label is a child of the same transformed group as Judge Bite and the counter. It must travel with the illustration during the hearing.
- The verdict's approval stamp crosses an image edge. The celebrating judge sits at the paper's lower empty corner, outside the ruling text.
- Short and narrow windows grow vertically. Do not crop text or shrink the price to fit. A production paywall should keep the purchase and free actions easy to reach while its content scrolls.
- The concept follows light/dark host appearance for paper and ink. Orange branding, illustrated assets, cream tickets and the navy hearing/verdict keep their designed colors.

### Tablet implementation direction

The interactive deliverable is the phone composition, centered in wider preview windows. It is not a claim that a tablet-native layout is implemented.

For the Flutter implementation, use the existing 760dp available-content breakpoint: illustration on the left (roughly 52%), headline, explanation, interaction and action on the right. Put the progress line in the right column. Keep the paywall at reading width with its membership scene beside the plan picker on wide landscape tablets. At 1.5× text or larger, return to a single scrollable column. All ten states need portrait/landscape and English/Spanish capture review before integration is complete.

## Motion score

These are finite sequences, not an always-bouncing background. A new screen gets one entrance; no timed reading advances. Sound is not part of this prototype.

| Moment | Timing | Behavior |
| --- | --- | --- |
| Route | 380ms | Fade with a restrained 18px lateral shift. |
| Copy / actions | 480ms; actions delayed 180ms | Short vertical entrance, then completely still. |
| Opening judge | 640ms | Bench and its live label arrive as one unit. Food cards stagger by 120/230ms. |
| Evidence lineup | 550ms; 80/180/280ms offsets | Individual cards settle at -8°, +8°, -2°. Text does not collide. |
| Inspecting evidence | 550–650ms | Photo arrives, inspector enters, then the note lands. Interaction produces one small acknowledgment. |
| Personality | 260–500ms | Pose and quote switch; a short response acknowledges the selected personality. |
| Hearing | 2050ms total | Food contenders rise and settle; the spotlight grows; the gavel character recoils at 74% and lands at 83% of a 1750ms sequence. |
| Hearing copy | 0 / 650 / 1550ms | Reviewing contenders → considering the chosen goal → reached a verdict. These are clearly a demo, not server progress. |
| Verdict ticket | 650ms after 180ms | Ticket feeds up into the dark stage. |
| Verdict judge | 600ms after 700ms | Celebrating pose emerges from the ticket corner. |
| Approval stamp | 350ms after 1000ms | Stamp scales from 1.65 to 0.94 to 1.0. |
| Confetti | 1600ms; 35ms per piece | One 16-piece burst. Verdict starts at its stamp; Plus welcome starts on entrance. |
| Press | 120ms | Raised action travels into its hard shadow. |

Reduced motion removes transforms, stagger delays, confetti and the hearing wait. It shows the final composed state immediately. Replay is hidden. Changing the OS preference during the hearing finishes directly at the verdict. Back/Skip cancels all hearing timers, so the result cannot unexpectedly open later.

## Membership and welcome logic

The user confirmed USD pricing:

| Plan | Primary amount | Disclosure |
| --- | --- | --- |
| Annual, initially selected | **$24.99/year** | $24.99 USD per year. Auto-renews. Cancel anytime. |
| Monthly | **$5.99/month** | $5.99 USD per month. Auto-renews. Cancel anytime. |

There is no invented free trial, introductory offer, artificial countdown, ratings claim, or numeric free quota. Annual may be tagged Best value. The full annual total remains primary; it is not disguised as a monthly equivalent.

Plus adds **unlimited decisions**. Photos, notes, all four goals, personalities and saved verdicts are core features, shown as shared features. The free welcome explicitly retains them. The exact free decision allowance and reset policy still need a product decision before billing integration; this design intentionally does not invent a number.

The visual uses the proposed name **FoodJury Plus** for the premium tier.

| Outcome | Production behavior | Preview behavior |
| --- | --- | --- |
| Offer opened | Show verified, localized store products | Uses the confirmed USD prices |
| Already premium | Skip the offer; show the Plus welcome | Plus welcome can be selected in the preview controls |
| Subscribe | Open platform purchase flow; confirm entitlement before premium welcome | Explicit “no payment” preview sheet, then Plus welcome |
| Canceled purchase | Keep selected plan and remain on offer; retain free action | Escape closes the preview sheet without changing membership |
| Pending purchase | Explain pending approval; do not mark premium prematurely | Specified here for implementation; not simulated as a purchase |
| Purchase failure | Explain the error, allow retry and free continuation | Specified here for implementation |
| Restore active membership | Verify entitlement, then Plus welcome | Explicit restoration preview, then Plus welcome |
| Nothing to restore | Explain no active membership was found; stay on offer | Specified here for implementation |
| Continue free | Show the warm free welcome | Fully clickable branch |
| Welcome action | Enter existing case builder, with selected preferences as appropriate | Explains the handoff and offers replay |

Restore purchases, Terms and Privacy remain accessible beneath the offer. Their prototype sheets identify missing production connections honestly. Connect real destinations and localized store pricing in implementation; never ship the explanatory design placeholders.

## Assets and provenance

Two new transparent illustrations were generated with the built-in image-generation tool, using existing Judge Bite poses as identity references:

- [Judge at the diner bench](assets/judge-at-counter.png), with [generation prompt](image-prompt.txt).
- [Judge inspecting evidence](assets/judge-inspecting-evidence.png), with [generation prompt](evidence-prompt.txt).

Existing poses, food illustrations and the wordmark come from the app's approved asset directories. The PNG originals stay intact. WebP files are smaller preview exports; resizing/compression does not repaint the illustrations. The detective has exactly two eyes, the lens enlarges one, and neither new pose has an open mouth or duplicate tongue.

App-created food art stays digital and illustrated. “Your photo goes here” is an explicitly illustrated example, not a generated food photograph and not user evidence sent to AI.

## Prototype and handoff files

- [prototype.html](prototype.html): editable, root-scoped HTML fragment with all ten screens and interaction states. Placeholder fonts/images are bundled by the preparation script.
- [prepare_preview.py](prepare_preview.py): embeds preview WebPs and WOFF2 subsets of existing app fonts. Requires `fonttools` and `brotli` in a development Python environment.
- [export-preview-assets.sh](export-preview-assets.sh): reproducible WebP exports using `cwebp`.
- Individual PNGs in this directory are actual renders of the interactive design, not AI-generated UI screenshots.
- [All ten screens](storyboard.png): full-resolution overview of the complete flow and both welcomes.
- [Animated walkthrough](onboarding-walkthrough.mp4): a recording of the working concept, including the hearing and verdict sequence.
- [Verification record](verification.json): viewport checks, interaction results, and checksums for the new original artwork.

The bundle is self-contained and below 1 MB. It performs no network requests. The only optional host persistence stores the current screen, selected goal, judge personality and plan. No photos, notes, billing credentials or user case data are collected.

## Validation

Browser verification covers all ten states at preview widths 736, 390 and 320 CSS pixels, with no horizontal page overflow, missing images or runtime errors. Screens were visually inspected to fix the original ticket/headline collisions, obscured food labels, and verdict text occlusion.

Interaction verification exercises sequential navigation, goal-dependent demo results, all four personalities, photo/note examples, annual/monthly disclosures, both welcome branches, restore preview, modal focus/inert behavior, hearing cancellation, replay, changing reduced motion mid-hearing and dark appearance. The Sol 6.1 high reviewer checked the prototype and accessibility/flow corrections; no actionable findings remain.

This is not a Flutter implementation, live purchase test, localization verification, or device-screen-reader certification. Production integration should use existing Diner widgets, ARB strings, persisted preferences, platform billing entitlement state and the app's real case-builder route.
