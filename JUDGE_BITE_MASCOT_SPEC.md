# Judge Bite — production character, version 2

The source of truth is `assets/images/judge_bite_v2/idle.png`, derived from the approved [diner judge](design/explorations/2026-10-11/round-2/d-diner-judge.png). The character is an orange gavel judge in a retro diner cartoon world.

## Identity

- Huge horizontal orange mallet head with rounded end caps and cream rim bands.
- Navy outlines, expressive oval eyes, thick movable eyebrows.
- Short navy judge robe and exactly two cream collar tabs.
- Rubber-hose arms and legs, cream four-finger cartoon gloves, oversized navy shoes with cream soles.
- Subtle flat shading and clean cutout transparency. No wig, hat, wood grain, handheld second gavel or realistic rendering.
- Warm, funny and opinionated. Emotion comes from eyebrows, eye direction, mouth and stance; every pose must not default to a grin.

## Required poses

| Filename | Expression and silhouette |
| --- | --- |
| `idle.png` | Open welcoming palm, jaunty step, broad smile |
| `waving.png` | Raised greeting glove |
| `thinking.png` | Hand on chin, eyes upward, furrowed eyebrow, pursed/downturned mouth |
| `stern.png` | Crossed arms, planted feet, lowered brows, half-lidded eyes, unsmiling mouth |
| `confused.png` | Head scratch and palm-up shrug, worried brows, small round mouth |
| `excited.png` | Eager forward energy and wide eyes |
| `celebrating.png` | Arms out and jumping stance, delighted expression |
| `sleeping.png` | Closed eyes and restful posture |
| `eating.png` | Pizza in one hand and thumbs-up in the other; a single cream mouth interior. The duplicate red tongue was corrected. |
| `pointing.png` | Clear directional presenting gesture |
| `plate.png` | Stern host balancing a porcelain plate, grounded full-body stance |
| `ticket.png` | Stern receipt draw with the numbered ticket held clear of the face |

| `bench.png` | Welcoming court host at the diner counter; imported from the approved onboarding artwork |
| `inspecting.png` | Magnifying glass inspecting optional evidence; imported from the approved onboarding artwork |
| `objection.png` | Open stop palm, arched skeptical eyebrow, restrained crooked smile |
| `filing.png` | Small ink stamp pressed to a blank folder, focused satisfied expression |
| `bell.png` | Ringing the service bell on a tray, raised brows and ready-to-eat energy |
| `whispering.png` | Cupped glove by mouth, conspiratorial glance and compact silhouette |

## Export and QA

Each pose is a separate square true-alpha PNG with the entire head, gloves and shoes inside the frame. Do not stretch/crop the silhouette or bake a checkerboard/background into the asset. Keep the navy contour clean against cream, orange, yellow and dark surfaces. Inspect expression, finger count, collar, teeth/mouth, limb attachment, edge clipping and alpha before installation.

The original generation prompts and facial corrections are in [design/production/prompts.json](design/production/prompts.json). Lucky Court pose provenance is recorded in [the exploration prompts](design/explorations/2026-10-11/random-court/prompts.json). The six-pose October 12 expansion is documented in [next-chapter prompts](design/production/next-chapter/prompts.json), including original source paths, dimensions, alpha and SHA-256 hashes. Use a current production pose as an image-generation reference for every new pose. Do not reinterpret the identity from prose alone.

## In-app usage

Use `JudgeBite` for a still expression and `JudgeBiteAnimated` for restrained breathing. Choose the pose to explain the state. Home can be happy; deliberation should look thoughtful; failures should look confused; stern personality should look unimpressed. Save celebration for a result or explicit delight moment.

Use `DinerCharacterStage` when the judge should break the layout: boots overlapping a raised action, speech bubble above the open palm, and small accent rays. Decorative imagery must not intercept taps or obscure readable text. Large-text mode simplifies the scene. Reduced motion keeps the same pose and composition without movement.

## Brand extensions

The app icon uses the same face and a small collar on a full-bleed mustard field. No external rounded corners; launcher masks are applied by the platform. The FoodJury script wordmark has cream letter faces, navy outline and hard shadow.

App-created food art belongs to the same illustrated style. Real photos supplied by users remain optional evidence in the decision flow. Never use AI-generated realistic food photography for decorative or sample content.

## Human portrait in the same world

`assets/images/me-diner.png` redraws Armando’s existing Memoji (`assets/images/me.png`) with the same heavy navy contour, cream highlights and warm cel shading. Preserve his recognizable short hair, complexion, upward glance and laptop pose. He remains a human developer, not another gavel judge. The original Memoji is retained. The exact built-in generation prompt is in `design/production/developer-portrait-prompt.txt`.
