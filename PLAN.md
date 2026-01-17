# FoodJury MVP - Phase 1 Design & Architecture Plan

## Overview
FoodJury is a fun, AI-powered food decision app featuring "Judge Bite" - a gavel mascot who delivers authoritative verdicts on food choices. Users can compare 2-5 food options with images, notes, and objectives, and the Judge decides with personality.

---

## 1. Tech Stack

| Layer | Technology | Rationale |
|-------|------------|-----------|
| **Framework** | Flutter | Cross-platform, single codebase |
| **State Management** | Riverpod 3.0 | Modern, compile-safe, excellent DX |
| **AI** | Gemini 2.5 Flash Lite via Firebase AI Logic | Cost-effective, multimodal, native Flutter SDK |
| **Local Storage** | Drift (SQLite) | Relational, reactive, well-maintained, excellent docs |
| **Animations** | Flutter native + Rive (future) | Static poses with transitions now, Rive-ready later |
| **Subscriptions** | RevenueCat (Phase 2) | Cross-platform IAP management |
| **Analytics** | Firebase Analytics + Crashlytics | Standard Firebase suite |

---

## 2. Design System

### 2.1 Color Palette (Warm & Appetizing)

```dart
// Primary Colors
primaryOrange: #FF6B35      // Main brand color - energetic, appetizing
primaryDark: #D4451A        // Darker shade for emphasis
primaryLight: #FF8C5A       // Lighter shade for backgrounds

// Secondary Colors
secondaryYellow: #FFB547    // Accents, highlights, Judge Bite glow
secondaryRed: #E63946       // Alerts, important verdicts
secondaryCream: #FFF8F0     // Warm background base

// Neutrals
darkBrown: #2D1810          // Primary text
warmGray: #6B5B4F           // Secondary text
lightBeige: #F5EDE4         // Card backgrounds
white: #FFFFFF              // Pure white for contrast

// Semantic
success: #4CAF50            // Healthy choice indicator
info: #5C9EFF              // Fun choice indicator
warning: #FFB547            // Fit choice indicator
```

### 2.2 Typography

```dart
// Font Family: Nunito (friendly, rounded) + Outfit (headings)
// Alternative: Poppins for both

headingLarge: Outfit Bold, 28sp      // Screen titles
headingMedium: Outfit SemiBold, 22sp // Section headers
headingSmall: Outfit Medium, 18sp    // Card titles

bodyLarge: Nunito Regular, 16sp      // Primary content
bodyMedium: Nunito Regular, 14sp     // Secondary content
bodySmall: Nunito Regular, 12sp      // Captions

// Judge Bite's Voice
verdictTitle: Outfit Black, 24sp     // "THE VERDICT"
verdictBody: Nunito SemiBold, 16sp   // Verdict reasoning
```

### 2.3 Component Style (Non-Material)

**Cards**: Soft rounded corners (16-20px), subtle shadows, cream backgrounds
**Buttons**: Pill-shaped, bold colors, slight bounce on press
**Inputs**: Rounded, warm border colors, friendly placeholder text
**Spacing**: Generous padding (16-24px), breathing room between elements
**Iconography**: Custom rounded icons, food-themed where possible

### 2.4 Motion Design Principles

- **Bouncy entrances**: Elements enter with slight overshoot (Curves.elasticOut)
- **Smooth exits**: Fade + scale down gently
- **Micro-interactions**: Buttons scale 95% on press, cards lift on hover/long-press
- **Judge Bite transitions**: Slide + fade between poses with personality

---

## 2.5 Visual Design Ideas (Screen by Screen)

### Overall Aesthetic
**Theme**: "Cozy Food Court" - warm, inviting, slightly retro diner vibes with modern touches
**Inspiration**: Mix of Duolingo's playfulness + Headspace's warmth + classic courtroom drama

### Splash Screen
```
┌────────────────────────────────┐
│                                │
│     ░░░░░░░░░░░░░░░░░░░░░     │  <- Warm gradient: cream → soft orange
│                                │
│         🔨                     │  <- Judge Bite bounces in
│        (◕‿◕)                   │     from bottom with gavel raised
│        /||\                    │
│                                │
│      ╔═══════════╗             │
│      ║ FoodJury  ║             │  <- Logo fades in with subtle glow
│      ╚═══════════╝             │
│                                │
│     "Order in the kitchen!"    │  <- Tagline fades in last
│                                │
└────────────────────────────────┘
```
- Background: Subtle radial gradient from cream center to soft orange edges
- Optional: Floating food icons (🍕🍔🥗) drift slowly in background

### Home Screen
```
┌────────────────────────────────┐
│  FoodJury              ⚙️      │  <- Warm header bar
├────────────────────────────────┤
│                                │
│   "Good evening, hungry one!"  │  <- Time-based greeting
│                                │
│        🔨                      │
│       (◕‿◕)  ← Judge Bite     │  <- Floating animation
│       /||\     idle pose       │
│                                │
│  ┌──────────────────────────┐  │
│  │                          │  │
│  │   🍽️  New Decision       │  │  <- BIG orange pill button
│  │                          │  │     Slight shadow, bouncy on tap
│  └──────────────────────────┘  │
│                                │
│  ─── Recent Verdicts ─────     │  <- Section divider with gavel icon
│                                │
│  ┌─────┐ ┌─────┐ ┌─────┐      │
│  │ 🍕  │ │ 🥗  │ │ 🍜  │      │  <- Horizontal scroll cards
│  │Pizza│ │Salad│ │Ramen│      │     Winner thumbnails
│  │ ✓   │ │ ✓   │ │ ✓   │      │     Tap to see full verdict
│  └─────┘ └─────┘ └─────┘      │
│                                │
└────────────────────────────────┘
```

**Empty State (no history)**:
```
┌────────────────────────────────┐
│                                │
│        🔨                      │
│       (・・?)  ← confused      │
│       /||\                     │
│                                │
│   "No verdicts yet..."         │
│                                │
│   "The court is empty!         │
│    Time to bring a case."      │
│                                │
│  ┌──────────────────────────┐  │
│  │   Start Your First Case  │  │  <- Points arrow at button
│  └──────────────────────────┘  │
│                                │
└────────────────────────────────┘
```

### New Decision Screen
```
┌────────────────────────────────┐
│  ← What's the dilemma?         │  <- Playful header
├────────────────────────────────┤
│                                │
│  YOUR OPTIONS                  │
│                                │
│  ┌─────────────────────────┐   │
│  │ 📷  +  "Pepperoni Pizza" │   │  <- Option card with image
│  │ [img]   🗒️ "Extra cheese" │   │     thumbnail, name, notes icon
│  │         ────────────  ✕  │   │     Swipe to delete
│  └─────────────────────────┘   │
│                                │
│  ┌─────────────────────────┐   │
│  │ 📷  +  "Caesar Salad"   │   │
│  │ [img]   🗒️               │   │
│  │         ────────────  ✕  │   │
│  └─────────────────────────┘   │
│                                │
│  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐   │
│  │    + Add Option          │   │  <- Dashed border, subtle
│  │      (tap to add)        │   │
│  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘   │
│                                │
│  WHAT'S YOUR GOAL?             │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐   │
│  │ 🎉 │ │ 🥬 │ │ 💪 │ │ ⚡ │   │  <- Horizontal chips
│  │Fun │ │Healthy│Fit│ │Quick│   │     Selected = filled orange
│  └────┘ └────┘ └────┘ └────┘   │
│                                │
│  ┌──────────────────────────┐  │
│  │  ⚖️ Let the Judge Decide │  │  <- Disabled until 2+ options
│  └──────────────────────────┘  │     Gavel icon animates on tap
│                                │
│          🔨                    │  <- Small Judge Bite in corner
│         (◕‿◕)                  │     Gets more excited as
│                                │     options are added
└────────────────────────────────┘
```

### Add Option Bottom Sheet
```
┌────────────────────────────────┐
│  ══════════════════════        │  <- Drag handle
│                                │
│  ADD OPTION                    │
│                                │
│  ┌────────────────────────┐    │
│  │                        │    │
│  │   📷   Tap to add      │    │  <- Large image picker area
│  │        photo           │    │     Camera or gallery choice
│  │                        │    │
│  └────────────────────────┘    │
│                                │
│  Name *                        │
│  ┌────────────────────────┐    │
│  │ What is it?            │    │  <- Rounded input, warm border
│  └────────────────────────┘    │
│                                │
│  Notes (optional)              │
│  ┌────────────────────────┐    │
│  │ Any details the judge  │    │
│  │ should know?           │    │  <- Textarea
│  └────────────────────────┘    │
│                                │
│  ┌──────────────────────────┐  │
│  │       Add to Case        │  │
│  └──────────────────────────┘  │
│                                │
└────────────────────────────────┘
```

### Loading/Processing State
```
┌────────────────────────────────┐
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│  <- Semi-transparent dark overlay
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│
│▒▒▒▒▒▒▒▒        🔨        ▒▒▒▒▒▒│  <- Judge Bite thinking pose
│▒▒▒▒▒▒▒       (•_•)       ▒▒▒▒▒│     Gavel taps chin
│▒▒▒▒▒▒▒       /||\        ▒▒▒▒▒│
│▒▒▒▒▒▒▒        💭         ▒▒▒▒▒│  <- Thought bubble appears/disappears
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│
│▒▒▒▒ "The court is in session..." ▒│  <- Rotating messages:
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│     "Examining the evidence..."
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│     "Deliberating..."
│▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│     "Almost there..."
└────────────────────────────────┘
```

### Verdict Screen (The Star!)
```
SEQUENCE:
1. Screen fades to dark
2. Drumroll sound effect (optional)
3. "THE VERDICT" slams down from top
4. Pause... dramatic tension
5. Winner card flies in with confetti burst
6. Judge Bite transitions to celebrating

┌────────────────────────────────┐
│                                │
│    ╔════════════════════╗      │
│    ║   THE VERDICT IS   ║      │  <- Gold/yellow text
│    ║        IN          ║      │     Outfit Black font
│    ╚════════════════════╝      │     Slams down animation
│                                │
│    ┌────────────────────┐      │
│    │   🏆              │      │  <- Crown/trophy overlay
│    │ ┌────────────────┐ │      │
│    │ │                │ │      │
│    │ │   [WINNER      │ │      │  <- Large winner image
│    │ │    IMAGE]      │ │      │     Gold border glow
│    │ │                │ │      │
│    │ └────────────────┘ │      │
│    │                    │      │
│    │  PEPPERONI PIZZA   │      │  <- Winner name, bold
│    │       🎉🎉🎉       │      │  <- Confetti animation
│    └────────────────────┘      │
│                                │
│         🔨                     │
│        \(◕‿◕)/  ← celebrating │
│         /||\                   │
│                                │
│  ═══ Judge's Notes ═══         │
│                                │
│  "The court finds in favor     │
│   of the pizza! The cheese     │  <- AI verdict in Judge's voice
│   pull alone sealed the deal." │
│                                │
│  ▼ See all rankings            │  <- Expandable
│                                │
│  ┌─────────┐  ┌─────────┐      │
│  │New Case │  │ Share 📤│      │  <- Action buttons
│  └─────────┘  └─────────┘      │
│                                │
└────────────────────────────────┘
```

### History Screen
```
┌────────────────────────────────┐
│  ← Past Verdicts               │
├────────────────────────────────┤
│                                │
│  Today                         │
│  ┌──────────────────────────┐  │
│  │ 🍕 │ Pizza vs Salad      │  │  <- Winner image left
│  │    │ 🎉 Fun              │  │     Objective badge
│  │    │ Jan 16, 2026        │  │     Date
│  │    │                  → │  │     Chevron to detail
│  └──────────────────────────┘  │
│                                │
│  Yesterday                     │
│  ┌──────────────────────────┐  │
│  │ 🍜 │ Ramen vs Sushi      │  │
│  │    │ 💪 Fit              │  │
│  │    │ Jan 15, 2026        │  │
│  │    │                  → │  │
│  └──────────────────────────┘  │
│                                │
│  This Week                     │
│  ┌──────────────────────────┐  │
│  │ 🌮 │ Tacos vs Burrito    │  │
│  │    │ ⚡ Quick             │  │
│  │    │ Jan 14, 2026        │  │
│  └──────────────────────────┘  │
│                                │
└────────────────────────────────┘
```

**Empty State**:
```
┌────────────────────────────────┐
│                                │
│         🔨                     │
│        (-.-)zzZ  ← sleeping   │
│        /||\                    │
│                                │
│   "The court records are       │
│         empty..."              │
│                                │
│   "No cases have been          │
│    decided yet!"               │
│                                │
└────────────────────────────────┘
```

### Settings Screen
```
┌────────────────────────────────┐
│  ← Settings                    │
├────────────────────────────────┤
│                                │
│  JUDGE'S PERSONALITY           │
│  ┌──────────────────────────┐  │
│  │ ⚖️ Stern & Fair    ●     │  │  <- Radio buttons
│  │    "The court finds..."   │  │     with preview text
│  ├──────────────────────────┤  │
│  │ 😏 Sassy           ○     │  │
│  │    "Listen, I've seen..." │  │
│  ├──────────────────────────┤  │
│  │ 🎉 Enthusiastic    ○     │  │
│  │    "OH WOW! This is..."   │  │
│  ├──────────────────────────┤  │
│  │ 😎 Chill           ○     │  │
│  │    "So like, here's..."   │  │
│  └──────────────────────────┘  │
│                                │
│  APPEARANCE                    │
│  ┌──────────────────────────┐  │
│  │ Theme                    │  │
│  │ ☀️ Light │ 🌙 Dark │ Auto│  │  <- Segmented control
│  └──────────────────────────┘  │
│                                │
│  SUBSCRIPTION                  │
│  ┌──────────────────────────┐  │
│  │ 👑 FoodJury Pro          │  │
│  │ Unlimited decisions      │  │
│  │                          │  │
│  │    [Upgrade Now]         │  │
│  └──────────────────────────┘  │
│                                │
│          🔨                    │  <- Small Judge Bite
│         (◕‿◕)                  │     reacts to changes
│                                │
│  About │ Privacy │ Terms       │
│                                │
└────────────────────────────────┘
```

### Error State (No Internet)
```
┌────────────────────────────────┐
│                                │
│                                │
│         🔨                     │
│        (-.-)  ← sleeping      │
│        /||\                    │
│         📡❌                   │
│                                │
│   "The court is offline..."    │
│                                │
│   "Wake me when we're          │
│    back online!"               │
│                                │
│  ┌──────────────────────────┐  │
│  │       Try Again          │  │
│  └──────────────────────────┘  │
│                                │
└────────────────────────────────┘
```

### Unique Design Elements

1. **Gavel Strike Animation**: When tapping the main CTA, a small gavel strikes effect
2. **Evidence Labels**: Options are labeled as "Exhibit A", "Exhibit B" for courtroom flavor
3. **Stamp Effect**: Verdict announcement has a red "APPROVED" stamp animation
4. **Paper Texture**: Subtle paper texture on card backgrounds for courtroom document feel
5. **Swipe Gestures**: Swipe cards left = "Objection!" (delete), swipe right = "Sustained" (keep)

---

## 3. Judge Bite Mascot System

### 3.1 Personality Configuration

Users can select Judge Bite's tone in settings:

| Tone | Description | Language Style |
|------|-------------|----------------|
| **Stern & Fair** (default) | Authoritative, dry humor | "The court has deliberated..." |
| **Sassy** | Witty, opinionated | "Listen, I've seen your choices..." |
| **Enthusiastic** | Excited, celebratory | "OH WOW! This is exciting!" |
| **Chill** | Relaxed, casual | "So like, here's the deal..." |

The selected tone is sent to Gemini as part of the prompt to style responses.

### 3.2 Judge Bite Poses (Static Assets)

Create these poses for Judge Bite (gavel character):

| Pose ID | State | Description | Usage |
|---------|-------|-------------|-------|
| `idle` | Neutral | Standing with gavel at rest | Default state |
| `thinking` | Processing | Looking up, gavel tapping chin | While AI processes |
| `excited` | Positive | Bouncing, gavel raised | Great choice moments |
| `stern` | Serious | Arms crossed, firm expression | Delivering verdict |
| `confused` | Error/Empty | Scratching head, tilted | Empty states, errors |
| `celebrating` | Victory | Jumping, confetti | Decision complete |
| `sleeping` | Idle timeout | Eyes closed, zzz | No activity |
| `eating` | Food context | Munching something | Loading food data |
| `pointing` | CTA | Pointing at something | Onboarding, hints |
| `waving` | Greeting | Friendly wave | Welcome, return user |

### 3.3 Judge Bite Appearance Map

| Screen/State | Pose | Animation | Notes |
|--------------|------|-----------|-------|
| **Splash Screen** | `waving` | Fade in + slight bounce | First impression |
| **Home (empty)** | `pointing` | Idle bob | Points to "New Decision" CTA |
| **Home (with history)** | `idle` | Subtle breathing | Watching over decisions |
| **New Decision (empty options)** | `confused` | Head tilt | "Add some options!" |
| **New Decision (filling)** | `excited` | Small bounce per option | Encouragement |
| **Processing/Loading** | `thinking` | Gavel tap loop | 2-3 second cycle |
| **Verdict Reveal** | `stern` → `celebrating` | Transition on reveal | Dramatic pause, then joy |
| **Error State** | `confused` | Shake head | "Something went wrong" |
| **No Internet** | `sleeping` | Float up/down | "Wake me when online" |
| **Settings** | `idle` | Blink occasionally | Passive presence |
| **Subscription Prompt** | `pointing` | Gesture to premium | Soft upsell |
| **Onboarding** | `waving` → `pointing` → `excited` | Guide through | Tutorial companion |

### 3.4 Animation Implementation

```dart
// Using Flutter's AnimatedSwitcher + custom transitions
class JudgeBite extends StatelessWidget {
  final JudgeBitePose pose;
  final Duration transitionDuration;

  // Poses transition with:
  // - Scale: 0.9 → 1.0
  // - Opacity: 0.0 → 1.0
  // - Slight Y offset: 10 → 0
  // - Curve: Curves.elasticOut for bounce
}

// Idle animations via AnimationController
// - Subtle floating (translateY oscillation)
// - Occasional blink (opacity flicker on eyes)
// - Breathing (scale 1.0 → 1.02 → 1.0)
```

---

## 4. Screen Designs

### 4.1 Screen Flow

```
┌─────────────┐
│   Splash    │
└──────┬──────┘
       ▼
┌─────────────┐     ┌─────────────┐
│  Onboarding │────▶│    Home     │
│  (first run)│     │             │
└─────────────┘     └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
       ┌───────────┐ ┌───────────┐ ┌───────────┐
       │   New     │ │  History  │ │ Settings  │
       │ Decision  │ │   List    │ │           │
       └─────┬─────┘ └─────┬─────┘ └───────────┘
             │             │
             ▼             ▼
       ┌───────────┐ ┌───────────┐
       │  Verdict  │ │  Decision │
       │  Screen   │ │  Detail   │
       └───────────┘ └───────────┘
```

### 4.2 Screen Details

#### Splash Screen
- **Duration**: 2-3 seconds
- **Content**: App logo, Judge Bite waving, warm gradient background
- **Animation**: Logo fades in, Judge Bite bounces in from bottom

#### Onboarding (3 screens)
1. **Welcome**: "Meet Judge Bite" - waving pose, explains the concept
2. **How it works**: Step through adding options - pointing pose
3. **Pick your style**: Select Judge's tone - shows different personalities

#### Home Screen
- **Header**: "FoodJury" title + settings icon
- **Hero Area**: Judge Bite with contextual greeting based on time/usage
- **Primary CTA**: Large "New Decision" button (pill, orange, bouncy)
- **Recent Decisions**: Horizontal scroll of last 3-5 decisions (cards)
- **Empty State**: Judge Bite confused, "No decisions yet. Let's change that!"

#### New Decision Screen
- **Header**: "What's the dilemma?" + back button
- **Options Section**:
  - 2-5 option cards (swipeable to remove)
  - Each card: Image thumbnail + name + notes icon
  - "Add Option" button (dashed border card)
- **Option Card Expanded** (bottom sheet):
  - Image picker (camera/gallery)
  - Name input
  - Notes textarea (optional)
- **Objective Selector**: Horizontal chips (Fun | Healthy | Fit | Quick)
- **Judge Bite**: Appears in corner, reacts to options being added
- **Submit CTA**: "Let the Judge Decide" (disabled until 2+ options)

#### Loading/Processing State
- **Full screen takeover** (semi-transparent overlay)
- **Judge Bite thinking pose** (center, large)
- **Text**: "The court is in session..." / "Deliberating..." / "Examining the evidence..."
- **Animation**: Gavel tapping, thinking bubbles

#### Verdict Screen
- **Dramatic Reveal**:
  1. Screen dims
  2. "THE VERDICT IS IN" text slams down
  3. Pause (500ms)
  4. Winner card animates in with confetti
  5. Judge Bite celebrates
- **Winner Display**:
  - Large image of winning option
  - Crown/trophy icon
  - Option name prominent
- **Reasoning Section**:
  - Judge Bite stern pose (small)
  - "Judge's Notes:" header
  - AI-generated reasoning in Judge's voice
- **Other Options**: Collapsed list showing rankings 2-5
- **Actions**: "New Decision" / "Share Verdict" / "Save"

#### History Screen
- **List View**: Cards with date, winner thumbnail, objective badge
- **Empty State**: Judge Bite sleeping, "No verdicts yet"
- **Card Content**:
  - Winner image (left)
  - Decision title/date
  - Objective chip
  - Tap to expand

#### Decision Detail Screen
- **Full verdict replay** (without animation)
- **All options shown** with rankings
- **Delete option** (with confirmation)

#### Settings Screen
- **Judge Bite Personality**: Tone selector (4 options)
- **Appearance**: Theme toggle (light/dark/system)
- **Subscription**: Current plan + upgrade CTA
- **About**: Version, credits, legal
- **Judge Bite**: Idle in corner, reacts to changes

---

## 5. Project Structure

```
lib/
├── main.dart
├── app.dart                          # App widget, routing, theme
│
├── config/
│   ├── theme/
│   │   ├── app_theme.dart            # ThemeData configuration
│   │   ├── app_colors.dart           # Color constants
│   │   ├── app_typography.dart       # Text styles
│   │   └── app_dimensions.dart       # Spacing, radius constants
│   ├── routes/
│   │   └── app_router.dart           # GoRouter configuration
│   └── constants/
│       └── app_constants.dart        # App-wide constants
│
├── core/
│   ├── utils/
│   │   ├── extensions.dart           # Dart extensions
│   │   └── helpers.dart              # Utility functions
│   ├── widgets/
│   │   ├── judge_bite.dart           # Judge Bite widget
│   │   ├── app_button.dart           # Custom button
│   │   ├── app_card.dart             # Custom card
│   │   ├── app_text_field.dart       # Custom input
│   │   ├── option_card.dart          # Food option card
│   │   ├── objective_chip.dart       # Objective selector chip
│   │   └── loading_overlay.dart      # Processing state
│   └── services/
│       ├── ai_service.dart           # Gemini API wrapper
│       └── storage_service.dart      # Drift database service
│
├── features/
│   ├── splash/
│   │   └── splash_screen.dart
│   │
│   ├── onboarding/
│   │   ├── onboarding_screen.dart
│   │   └── onboarding_provider.dart
│   │
│   ├── home/
│   │   ├── home_screen.dart
│   │   ├── home_provider.dart
│   │   └── widgets/
│   │       ├── recent_decisions_list.dart
│   │       └── home_empty_state.dart
│   │
│   ├── decision/
│   │   ├── new_decision_screen.dart
│   │   ├── verdict_screen.dart
│   │   ├── decision_provider.dart
│   │   ├── models/
│   │   │   ├── decision.dart
│   │   │   ├── food_option.dart
│   │   │   └── objective.dart
│   │   └── widgets/
│   │       ├── option_input_sheet.dart
│   │       ├── objective_selector.dart
│   │       ├── verdict_reveal.dart
│   │       └── winner_card.dart
│   │
│   ├── history/
│   │   ├── history_screen.dart
│   │   ├── decision_detail_screen.dart
│   │   ├── history_provider.dart
│   │   └── widgets/
│   │       └── history_card.dart
│   │
│   └── settings/
│       ├── settings_screen.dart
│       ├── settings_provider.dart
│       └── widgets/
│           ├── tone_selector.dart
│           └── subscription_card.dart
│
├── data/
│   ├── models/
│   │   ├── decision_model.dart       # Drift model
│   │   ├── food_option_model.dart    # Drift model
│   │   └── user_preferences.dart     # Settings model
│   ├── repositories/
│   │   ├── decision_repository.dart
│   │   └── preferences_repository.dart
│   └── datasources/
│       ├── local/
│       │   └── drift_database.dart
│       └── remote/
│           └── gemini_datasource.dart
│
└── providers/
    ├── app_providers.dart            # Global providers
    ├── theme_provider.dart
    └── subscription_provider.dart

assets/
├── images/
│   ├── judge_bite/
│   │   ├── idle.png
│   │   ├── thinking.png
│   │   ├── excited.png
│   │   ├── stern.png
│   │   ├── confused.png
│   │   ├── celebrating.png
│   │   ├── sleeping.png
│   │   ├── eating.png
│   │   ├── pointing.png
│   │   └── waving.png
│   ├── logo.png
│   └── onboarding/
├── fonts/
│   ├── Nunito/
│   └── Outfit/
└── animations/
    └── confetti.json                 # Lottie for verdict celebration
```

---

## 6. Data Models

### 6.1 Decision Model (Drift)

```dart
// Database tables defined with Drift
class Decisions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get objective => text()();           // fun, healthy, fit, quick
  IntColumn get winnerOptionId => integer().references(FoodOptions, #id)();
  TextColumn get verdict => text()();             // AI-generated reasoning
  TextColumn get judgeTone => text()();           // Tone used for this decision
}

class FoodOptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get decisionId => integer().references(Decisions, #id)();
  TextColumn get name => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get imagePath => text().nullable()(); // Local file path
  IntColumn get rank => integer()();               // 1 = winner, 2 = second, etc.
}

enum Objective { fun, healthy, fit, quick }
```

### 6.2 User Preferences

```dart
class UserPreferences {
  final String judgeTone;             // stern, sassy, enthusiastic, chill
  final ThemeMode themeMode;
  final bool hasCompletedOnboarding;
  final int freeDecisionsUsedToday;
  final DateTime? lastDecisionDate;
  final SubscriptionTier subscription;
}

enum SubscriptionTier { free, weekly, annual }
```

---

## 7. AI Prompt Structure

```dart
String buildPrompt({
  required List<FoodOption> options,
  required Objective objective,
  required String tone,
  List<Decision>? recentDecisions,  // Phase 2
}) {
  return '''
You are Judge Bite, a gavel-shaped food court judge. Your personality is: $tone.

TONE GUIDELINES:
- stern: Formal, authoritative, dry wit. "The court finds..."
- sassy: Playful, opinionated, witty. "Honestly? Let's be real here..."
- enthusiastic: Excited, celebratory. "OH! This is such a great lineup!"
- chill: Casual, relaxed. "Alright, so here's the vibe..."

OBJECTIVE: The user wants a ${objective.name} choice.

OPTIONS:
${options.mapIndexed((i, o) => '''
${i + 1}. ${o.name}
   Notes: ${o.notes ?? 'None'}
   [Image attached if provided]
''').join('\n')}

TASK:
1. Analyze each option against the "${objective.name}" objective
2. Consider any notes provided
3. If images are provided, analyze them for context
4. Deliver your VERDICT - pick ONE winner
5. Rank all options from best to worst
6. Provide reasoning in your character's voice (2-3 sentences)

RESPONSE FORMAT (JSON):
{
  "winner": 1,
  "rankings": [1, 3, 2],
  "verdict": "Your reasoning here in character..."
}
''';
}
```

---

## 8. MVP Feature Checklist

### Must Have (Phase 1)
- [ ] Splash screen with Judge Bite
- [ ] Onboarding flow (3 screens)
- [ ] Home screen with empty/populated states
- [ ] Create decision with 2-5 options
- [ ] Add name + optional notes per option
- [ ] Add image per option (camera/gallery)
- [ ] Select objective (fun/healthy/fit/quick)
- [ ] Judge Bite processing animation
- [ ] Verdict screen with reveal animation
- [ ] Save all decisions to local storage (Drift)
- [ ] History list view
- [ ] Decision detail view
- [ ] Settings: Judge tone selector
- [ ] Settings: Theme (light/dark/system)

### Nice to Have (Phase 1.5)
- [ ] Share verdict as image
- [ ] Confetti animation (Lottie)
- [ ] Haptic feedback on verdict
- [ ] Sound effects (optional, toggleable)

### Phase 2 (Future)
- [ ] RevenueCat subscription setup
- [ ] Free tier: 5 decisions/day limit
- [ ] AdMob integration (banner + interstitial after verdict)
- [ ] AI uses decision history for context
- [ ] User dietary preferences/restrictions
- [ ] Multiple Judge Bite skins
- [ ] Social sharing to socials
- [ ] Widget for quick decisions

---

## 9. Verification & Testing

### Manual Testing Checklist
1. **Fresh install flow**: Onboarding → First decision → Verdict
2. **Decision creation**: Test 2, 3, 4, 5 options
3. **Image handling**: Camera, gallery, no image
4. **All objectives**: Test each objective type
5. **All Judge tones**: Verify personality in responses
6. **History persistence**: Kill app, reopen, verify data
7. **Empty states**: All screens without data
8. **Error states**: No internet, API failure
9. **Free limit**: Hit 5 decisions, verify limit
10. **Subscription flow**: Purchase and verify unlimited

### Automated Tests
- Unit tests for Riverpod providers
- Unit tests for AI prompt building
- Widget tests for core components
- Integration tests for decision flow

---

## 10. Asset Requirements for Designer

### Judge Bite Poses Needed
Provide these 10 poses at 2x and 3x resolution (PNG with transparency):

1. **idle.png** - Neutral standing pose
2. **thinking.png** - Looking up, gavel on chin
3. **excited.png** - Bouncing, gavel raised high
4. **stern.png** - Arms crossed, serious face
5. **confused.png** - Head tilted, scratching head
6. **celebrating.png** - Jumping with joy
7. **sleeping.png** - Eyes closed, zzz bubbles
8. **eating.png** - Munching on food
9. **pointing.png** - Pointing to the right
10. **waving.png** - Friendly wave

**Style notes**:
- Warm color palette (oranges, browns, cream)
- Friendly but authoritative expression
- Gavel body with arms, legs, face
- Consistent proportions across all poses
- Consider: judge wig or collar for character

### Other Assets
- App icon (multiple sizes)
- Logo wordmark
- Onboarding illustrations (3)
- Objective icons (fun, healthy, fit, quick)
- Empty state illustrations
- Confetti Lottie animation

---

## Current Status

### Completed ✅
1. **Design Phase**: Full design system documented (colors, typography, components)
2. **Project Setup**: Flutter project initialized with folder structure
3. **Architecture**: Riverpod 3.0 + GoRouter + Drift configured
4. **Dependencies**: All packages added to pubspec.yaml

### In Progress 🔄
5. **Build Environment Issue**: Flutter SDK path contains space (`C:\Users\Armando PC\sdk\flutter`) which breaks native compilation for `objective_c` package during iOS builds.
   - **Workaround needed**: Move Flutter SDK to a path without spaces (e.g., `C:\flutter`) and update PATH environment variable.
   - This only affects iOS builds; Android should work fine.

### Next Steps

1. **Fix Flutter SDK Path** (blocking for iOS builds)
   - Move Flutter SDK to `C:\flutter`
   - Update system PATH variable
   - Run `flutter doctor` to verify

2. **Core Widgets**: Build design system components
3. **Home + Decision Flow**: Implement main user journey
4. **AI Integration**: Connect Firebase AI Logic + Gemini
5. **Storage**: Set up Drift for decision history
6. **Monetization**: RevenueCat subscription integration
7. **Polish**: Animations, transitions, empty states
8. **Testing**: Full test pass
9. **Launch**: App store submission
