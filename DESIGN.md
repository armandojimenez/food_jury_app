# FoodJury Design System

> **Retro Diner Courtroom** - A bold, playful design system inspired by 1950s American diners meets courtroom drama.

---

## Overview

FoodJury uses a distinctive design language that blends:
- **Retro Diner Aesthetics**: Neon orange, chrome accents, chunky borders, hard shadows
- **Courtroom Authority**: Bold verdicts, dramatic reveals, authoritative typography
- **Modern Playfulness**: Smooth animations, friendly interactions, delightful micro-moments

The design is **unapologetically bold** - orange dominates, shadows are hard, and nothing is timid.

---

## Color Palette

### Philosophy
High contrast, warm, appetizing. Orange DOMINATES the interface, navy provides sharp contrast for text and authority, and mustard yellow sparks highlight moments.

### Primary Colors

```
🔥 PRIMARY ORANGE (Dominant - Use Generously)
#FF6B35 - Blazing Orange
  ├─ #E55A2B - Primary Dark (pressed states)
  └─ #FF8A5C - Primary Light (subtle backgrounds)

Uses: Buttons, headers, Judge Bite, food highlights, CTAs
Think: Neon diner signs, hot sauce, passion
```

### Accent Colors

```
⚫ ACCENT NAVY (Sharp Contrast)
#1A1A2E - Deep Navy (almost black)
  └─ #2D2D44 - Accent Light (secondary text)

Uses: Text, borders, Judge's robe, authority elements
Think: Courtroom seriousness, official documents
```

### Pop Colors

```
⚡ POP MUSTARD (Use Sparingly - Highlights Only)
#FFD23F - Mustard Yellow
  └─ #E5BC38 - Pop Dark (depth)

Uses: Badges, star ratings, special highlights, accents
Think: Diner booth stitching, vintage chrome details
```

### Background & Surface

```
🧈 BACKGROUND CREAM
#FFF8F0 - Warm Cream (primary background)
#FFFFFF - Surface (cards, elevated elements)
#E8E0D8 - Border (subtle dividers)

Think: Diner menu paper, warm and inviting
```

### Semantic Colors

```
✅ SUCCESS: #2ECC71 - Victory Green ("The Winner!")
⚠️ WARNING: #F39C12 - Caution Orange ("Hmm, maybe...")
❌ ERROR: #E74C3C - Rejection Red ("Case Dismissed!")
ℹ️ INFO: #3498DB - Info Blue (neutral information)
```

### Special Effects

```
✨ CHROME: #C0C0C0 / #E8E8E8 - Diner shine
🌑 OVERLAY: rgba(0,0,0,0.6) - Modals
👤 SHADOW: rgba(0,0,0,0.16) - Depth
```

### Color Usage Guidelines

| Usage | Primary | Accent | Pop | Background |
|-------|---------|--------|-----|------------|
| **Text** | Sparingly | ✅ Primary | Highlights | Never |
| **Backgrounds** | Buttons | Borders | Badges | ✅ Primary |
| **CTAs** | ✅ Dominant | Outlines | Icons | Never |
| **Borders** | Cards | ✅ Text areas | Special | Dividers |

---

## Typography

### Philosophy
**Display Font (Bangers)**: Chunky, fun, diner-sign energy for headlines and verdicts  
**Body Font (Nunito)**: Warm, readable, friendly but professional for content

### Font Families

```dart
Display: 'Bangers' - For headlines, verdicts, big moments
Body: 'Nunito' - For readable text, descriptions, UI
```

### Type Scale

```
┌─────────────────────────────────────────────────────┐
│ DISPLAY STYLES - Big, Bold, Unforgettable          │
├─────────────────────────────────────────────────────┤
│ displayLarge    Bangers 48px   "PIZZA WINS!"       │
│ displayMedium   Bangers 36px   "THE VERDICT IS IN" │
│ displaySmall    Bangers 28px   "Tonight's Menu"    │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ HEADLINE STYLES - Important but not screaming      │
├─────────────────────────────────────────────────────┤
│ headlineLarge   Nunito Bold 32px                   │
│ headlineMedium  Nunito Bold 28px                   │
│ headlineSmall   Nunito SemiBold 24px               │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ TITLE STYLES - UI Element Labels                   │
├─────────────────────────────────────────────────────┤
│ titleLarge      Nunito SemiBold 22px               │
│ titleMedium     Nunito SemiBold 18px               │
│ titleSmall      Nunito SemiBold 14px               │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ BODY STYLES - Readable Content                     │
├─────────────────────────────────────────────────────┤
│ bodyLarge       Nunito Regular 16px                │
│ bodyMedium      Nunito Regular 14px                │
│ bodySmall       Nunito Regular 12px                │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ LABEL STYLES - Buttons, Tags                       │
├─────────────────────────────────────────────────────┤
│ labelLarge      Nunito Bold 16px                   │
│ labelMedium     Nunito SemiBold 14px               │
│ labelSmall      Nunito SemiBold 12px               │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ SPECIAL STYLES - Unique Elements                   │
├─────────────────────────────────────────────────────┤
│ verdict         Bangers 56px  ALL CAPS, dramatic   │
│ foodTitle       Bangers 24px  Food option names    │
│ judgeSpeech     Nunito SemiBold Italic 16px        │
│ priceTag        Bangers 20px  Retro diner style    │
└─────────────────────────────────────────────────────┘
```

### Typography Guidelines

- **Display styles**: Use for attention-grabbing moments (verdicts, winners, screen titles)
- **Bangers**: Always ALL CAPS or Title Case - it's meant to SHOUT
- **Nunito**: Warm and readable - use for all body content
- **Letter spacing**: Display has wider spacing for drama, body is tighter for readability
- **Line height**: Generous (1.4-1.5) for body text, tighter (1.1-1.2) for display

---

## Spacing & Layout

### Philosophy
**Generous but not wasteful.** Breathing room is crucial for a warm, inviting feel.

### Spacing Scale

```
┌─────────────────────────────────────┐
│ spaceXxs    2px   Micro elements    │
│ spaceXs     4px   Tight spacing     │
│ spaceSm     8px   Related items     │
│ spaceMd    16px   Standard gap      │ ← Most common
│ spaceLg    24px   Section spacing   │
│ spaceXl    32px   Major sections    │
│ spaceXxl   48px   Screen sections   │
│ spaceXxxl  64px   Hero spacing      │
└─────────────────────────────────────┘
```

### Screen Padding

```dart
Horizontal: 20px  // Edges of screen
Vertical: 24px    // Top/bottom breathing room
```

### Layout Principles

1. **Generous Padding**: Cards and buttons have plenty of internal space
2. **Obvious Hierarchy**: Use spacing to show relationships (16px within groups, 32px between sections)
3. **Rhythm**: Consistent spacing creates visual rhythm - stick to the scale
4. **Breathing Room**: Don't cram elements - let them breathe

---

## Borders & Corners

### Philosophy
**Chunky and confident.** Retro diner aesthetics demand bold borders.

### Border Radius

```
┌─────────────────────────────────────────┐
│ radiusSm     8px   Subtle rounding      │
│ radiusMd    16px   Standard cards       │ ← Default
│ radiusLg    24px   Prominent elements   │
│ radiusXl    32px   Pills, rounded CTA   │
│ radiusFull 999px   Circular elements    │
└─────────────────────────────────────────┘
```

### Border Width

```
┌─────────────────────────────────────────┐
│ borderThin     1px   Subtle borders     │
│ borderMedium   2px   Standard           │
│ borderThick    3px   Retro diner style  │ ← Signature
│ borderChunky   4px   Extra special      │
└─────────────────────────────────────────┘
```

### Border Guidelines

- **Default**: 16px radius, 3px thick border for cards
- **Buttons**: Fully rounded (radiusXl) with 3px borders
- **Inputs**: 12-16px radius, 2px border
- **Judge Bite cards**: Slight tilt (0.02 rad) for personality

---

## Shadows & Elevation

### Philosophy
**Two shadow systems**: Soft modern shadows for depth, hard retro shadows for diner vibes.

### Modern Shadows (Soft, Blurred)

```
┌────────────────────────────────────────────┐
│ shadowSm   4px blur, 2px offset   Subtle   │
│ shadowMd   8px blur, 4px offset   Cards    │
│ shadowLg  16px blur, 8px offset   Modals   │
│ shadowXl  24px blur, 12px offset  Dramatic │
└────────────────────────────────────────────┘

Use for: Standard cards, buttons, overlays
```

### Retro Shadows (Hard, No Blur)

```
┌────────────────────────────────────────────┐
│ shadowRetro       0 blur, 4x4 offset       │
│ shadowRetroSm     0 blur, 2x2 offset       │
└────────────────────────────────────────────┘

Color: Deep Navy (#1A1A2E)

Use for: Food cards, special elements, diner aesthetic
```

### Elevation Guidelines

```
Level 0: Background (no shadow)
Level 1: Resting cards (shadowSm or shadowRetroSm)
Level 2: Raised cards, buttons (shadowMd or shadowRetro)
Level 3: Floating action buttons (shadowLg)
Level 4: Modals, dialogs (shadowXl)
```

---

## Components

### Buttons

```
┌─────────────────────────────────────────────────────┐
│ PRIMARY BUTTON (The Hero CTA)                       │
├─────────────────────────────────────────────────────┤
│ Style: Pill-shaped, blazing orange, white text     │
│ Height: 52-60px                                     │
│ Radius: 32px (fully rounded)                        │
│ Border: 3px solid primaryDark                       │
│ Shadow: shadowMd                                     │
│ Interaction: Scale to 95% on press, bounce back    │
│                                                     │
│ Example: "LET THE JUDGE DECIDE"                     │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ SECONDARY BUTTON (Supporting actions)               │
├─────────────────────────────────────────────────────┤
│ Style: Outlined, navy border, transparent           │
│ Height: 52px                                        │
│ Border: 2px solid accent                            │
│ Text: Navy, medium weight                           │
│                                                     │
│ Example: "Add Option"                               │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ ICON BUTTON (Utility actions)                       │
├─────────────────────────────────────────────────────┤
│ Size: 40x40px                                       │
│ Icon: 24px                                          │
│ Interaction: Subtle scale on press                  │
└─────────────────────────────────────────────────────┘
```

### Cards

```
┌─────────────────────────────────────────────────────┐
│ FOOD OPTION CARD (Retro Style)                      │
├─────────────────────────────────────────────────────┤
│ Background: White                                   │
│ Border: 3px solid accent                            │
│ Radius: 16px                                        │
│ Shadow: shadowRetro (hard 4x4 offset)               │
│ Tilt: 0.02 radians for personality                  │
│                                                     │
│ Layout:                                             │
│ ┌──────────────────────────────┐                   │
│ │ [📷 80x80] │ FOOD NAME        │                   │
│ │ [  Image ] │ Description text │                   │
│ │            │ 🗒️ Notes icon    │                   │
│ └──────────────────────────────┘                   │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ VERDICT CARD (Dramatic Winner Reveal)               │
├─────────────────────────────────────────────────────┤
│ Background: Gradient (primary → primaryDark)        │
│ Border: 4px solid pop (mustard yellow)              │
│ Radius: 16px                                        │
│ Shadow: shadowXl                                     │
│ Tilt: -3 degrees rotation                           │
│ Overlay: Crown/trophy icon                          │
│                                                     │
│ Animation: Flies in from bottom with confetti       │
└─────────────────────────────────────────────────────┘
```

### Inputs

```
┌─────────────────────────────────────────────────────┐
│ TEXT INPUT                                          │
├─────────────────────────────────────────────────────┤
│ Height: 52px                                        │
│ Border: 2px solid border                            │
│ Radius: 12px                                        │
│ Padding: 16px horizontal                            │
│ Focus: Border becomes primary orange                │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ OBJECTIVE CHIP (Selector)                           │
├─────────────────────────────────────────────────────┤
│ Unselected: White bg, navy border, navy text       │
│ Selected: Orange bg, orange border, white text     │
│ Height: 40px                                        │
│ Radius: 20px (pill)                                 │
│ Icon: 20px emoji (🎉 🥬 💪 ⚡)                       │
└─────────────────────────────────────────────────────┘
```

### Judge Bite Widget

```
┌─────────────────────────────────────────────────────┐
│ JUDGE BITE MASCOT                                   │
├─────────────────────────────────────────────────────┤
│ Poses:                                              │
│  • idle - Neutral standing                          │
│  • thinking - Gavel on chin                         │
│  • excited - Gavel raised high                      │
│  • stern - Arms crossed                             │
│  • confused - Head tilted                           │
│  • celebrating - Jumping with joy                   │
│  • sleeping - Zzz bubbles                           │
│  • pointing - Pointing right                        │
│  • waving - Friendly wave                           │
│                                                     │
│ Sizes:                                              │
│  • Small: 60px (corner presence)                    │
│  • Medium: 100px (companion)                        │
│  • Large: 160px (hero)                              │
│  • XLarge: 220px (splash/onboarding)                │
│                                                     │
│ Animation: Smooth 300ms transitions between poses   │
│ Idle: Subtle floating (translateY oscillation)      │
└─────────────────────────────────────────────────────┘
```

---

## Motion & Animation

### Philosophy
**Bouncy, playful, but never annoying.** Animations add personality without slowing the user down.

### Duration Scale

```
durationFast     150ms   Micro-interactions (hover, press)
durationMedium   300ms   Standard transitions
durationSlow     500ms   Elaborate animations
durationDramatic 800ms   Verdict reveals
durationPage     350ms   Page transitions
```

### Animation Curves

```
curveSnappy      easeOutCubic      Quick responses
curveSmooth      easeInOutCubic    Standard transitions
curveBouncy      elasticOut        Playful entrances
curveDramatic    easeOutBack       Verdict slam
curveAnticipate  easeInBack        Pull back then release
```

### Animation Patterns

```
┌─────────────────────────────────────────────────────┐
│ PATTERN: Button Press                               │
├─────────────────────────────────────────────────────┤
│ 1. Scale to 95% (150ms, easeOutCubic)              │
│ 2. Scale to 100% (300ms, elasticOut)               │
│ 3. Optional haptic feedback                         │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ PATTERN: Card Entrance                              │
├─────────────────────────────────────────────────────┤
│ 1. Start: Opacity 0, translateY +20px              │
│ 2. Animate: 300ms, easeOutCubic                    │
│ 3. Slight overshoot on bounce                       │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ PATTERN: Verdict Reveal (The Showstopper!)         │
├─────────────────────────────────────────────────────┤
│ 1. Screen dims (overlay fades in)                   │
│ 2. "THE VERDICT IS IN" slams down from top          │
│ 3. Pause 500ms (dramatic tension)                   │
│ 4. Winner card flies up from bottom                 │
│ 5. Confetti burst                                   │
│ 6. Judge Bite transitions celebrating               │
│ Total: ~2.5 seconds of theater                      │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ PATTERN: Judge Bite Pose Transition                 │
├─────────────────────────────────────────────────────┤
│ 1. Fade out current (150ms)                         │
│ 2. Scale from 0.9 to 1.0                            │
│ 3. Fade in new pose (300ms, elasticOut)            │
│ 4. Subtle Y offset for bounce                       │
└─────────────────────────────────────────────────────┘
```

### Micro-Interactions

- **Hover** (web/desktop): Subtle lift (2px up, lighter shadow)
- **Press**: Scale down to 95%, snap back with bounce
- **Focus**: Animated border color change
- **Loading**: Rotate spinner OR gavel tapping animation
- **Success**: Brief scale pulse (1.0 → 1.05 → 1.0)
- **Error**: Horizontal shake (3 oscillations)

---

## Iconography

### Style
- **Rounded**: Friendly, approachable
- **Food-themed**: Where possible (🍕 🍔 🥗 🌮)
- **Emoji support**: Objectives use emoji for instant recognition

### Icon Sizes

```
iconSizeSm   16px   Inline with text
iconSizeMd   24px   Standard UI icons
iconSizeLg   32px   Prominent actions
iconSizeXl   48px   Hero elements
```

### Icon Set Recommendations

- **Material Icons Rounded** - Primary set
- **Custom icons** - Food items, Judge Bite gavel, verdict stamps

---

## Gradients & Special Effects

### Gradients

```dart
// Primary Energy Gradient
primaryGradient: linear-gradient(
  topLeft → bottomRight,
  #FF6B35 → #E55A2B
)
Use: Buttons, headers, hero sections

// Verdict Stamp Gradient
verdictGradient: linear-gradient(
  top → bottom,
  #FF6B35 → #CC4400
)
Use: Winner cards, verdict stamps

// Chrome Shine (Retro Diner)
chromeGradient: linear-gradient(
  top → bottom,
  #E8E8E8 → #C0C0C0 → #E8E8E8
  stops: [0%, 50%, 100%]
)
Use: Decorative chrome elements

// Warm Background
backgroundGradient: linear-gradient(
  top → bottom,
  #FFF8F0 → #FFF0E0
)
Use: Screen backgrounds for subtle depth
```

### Special Values

```dart
verdictTiltAngle  0.052 rad (~3°)   Verdict card tilt
cardStackTilt     0.02 rad (~1°)    Stacked card effect
gavelSlamScale    1.15               Gavel press emphasis
screenShakeOffset 8px                Error shake distance
```

---

## Accessibility

### Color Contrast

All text meets WCAG AA standards:
- **Primary on Background**: 4.5:1+ (navy on cream)
- **White on Primary**: 4.5:1+ (white on orange)
- **Primary on White**: 3:1+ (orange on white for large text)

### Tap Targets

- **Minimum**: 44x44px for all interactive elements
- **Preferred**: 52x52px for primary actions

### Motion

- Respect `prefers-reduced-motion` system setting
- Provide option to disable animations in settings
- Essential animations (loading) remain, decorative ones removed

### Focus States

- Visible focus indicators (2px primary border)
- Logical tab order
- Semantic HTML/Widget structure

---

## Dark Mode (Phase 2)

Future dark mode palette:

```
Background: #1A1A2E (deep navy)
Surface: #2D2D44 (lighter navy)
Primary: #FF8A5C (lighter orange for readability)
Text: #FFF8F0 (warm cream)
Border: #3D3D54 (muted)
```

---

## Asset Requirements

### Judge Bite Poses

10 poses needed at 2x and 3x resolution (PNG with transparency):

1. **idle.png** - Neutral standing
2. **thinking.png** - Gavel on chin
3. **excited.png** - Gavel raised high
4. **stern.png** - Arms crossed
5. **confused.png** - Head tilted
6. **celebrating.png** - Jumping  
7. **sleeping.png** - Zzz bubbles
8. **eating.png** - Munching food
9. **pointing.png** - Pointing right
10. **waving.png** - Wave greeting

**Style Notes**:
- Warm color palette (oranges, browns, cream)
- Gavel body with arms, legs, expressive face
- Optional: Small judge wig or collar
- Consistent proportions across poses

### App Assets

- **App icon** (multiple sizes for iOS/Android)
- **Logo wordmark** (FoodJury)
- **Objective icons** (if not using emoji)
- **Empty state illustrations** (3-4 scenes)
- **Confetti animation** (Lottie JSON)

---

## Development Guidelines

### File Organization

```
lib/core/theme/
  ├── app_colors.dart       All color constants
  ├── app_typography.dart   Text styles
  ├── app_dimensions.dart   Spacing, sizing, animations
  └── app_theme.dart        ThemeData assembly
```

### Using the Design System

```dart
// ✅ GOOD - Use design tokens
Container(
  padding: const EdgeInsets.all(AppDimensions.spaceMd),
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: AppDimensions.borderRadiusMd,
    border: Border.all(
      color: AppColors.accent,
      width: AppDimensions.borderThick,
    ),
  ),
  child: Text(
    'Welcome!',
    style: AppTypography.headlineLarge,
  ),
)

// ❌ BAD - Magic numbers and hard-coded values
Container(
  padding: const EdgeInsets.all(14.0),  // Don't do this!
  decoration: BoxDecoration(
    color: Color(0xFFFFFFFF),             // Use AppColors!
    borderRadius: BorderRadius.circular(15.0),  // Use tokens!
  ),
  child: Text(
    'Welcome!',
    style: TextStyle(fontSize: 28),      // Use AppTypography!
  ),
)
```

### Never Override

- Don't create one-off colors - extend `AppColors` if needed
- Don't use random spacing values - stick to the scale
- Don't bypass animation durations - use the constants
- Don't create custom text styles - use existing or add to `AppTypography`

---

## Design Checklist

When implementing a new screen or component:

- [ ] Uses only `AppColors` constants
- [ ] Uses only `AppTypography` text styles
- [ ] Spacing follows `AppDimensions` scale
- [ ] Borders use standard radius and width
- [ ] Shadows use predefined lists
- [ ] Animations use standard durations and curves
- [ ] Tap targets minimum 44x44px
- [ ] Color contrast meets WCAG AA
- [ ] Respects `prefers-reduced-motion`
- [ ] Works in both light mode (dark mode later)

---

## Quick Reference

### Most Common Values

```dart
// Spacing
AppDimensions.spaceMd        // 16px - Standard gap
AppDimensions.spaceLg        // 24px - Section spacing

// Colors
AppColors.primary            // Orange - CTAs, headers
AppColors.accent             // Navy - Text, borders
AppColors.surface            // White - Cards

// Typography
AppTypography.displayMedium  // Bangers 36px - Titles
AppTypography.bodyLarge      // Nunito 16px - Content
AppTypography.labelLarge     // Nunito Bold 16px - Buttons

// Borders
AppDimensions.borderRadiusMd // 16px - Cards
AppDimensions.borderThick    // 3px - Retro borders

// Shadows
AppDimensions.shadowRetro    // Hard 4x4 - Food cards
AppDimensions.shadowMd       // Soft blur - Standard
```

---

## Version History

- **v1.0** - Initial design system (Retro Diner Courtroom theme)
- Future: Dark mode, additional Judge Bite skins, seasonal themes

---

**Designed with ❤️ and 🍕 for FoodJury**
