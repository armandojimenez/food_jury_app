# Judge Bite - Complete Mascot Specification

## 🎨 **Character Overview**

**Judge Bite** is the star mascot of FoodJury - a friendly, authoritative gavel character who helps users make food decisions with personality and flair.

### **Core Identity**
- **Species**: Anthropomorphic wooden gavel
- **Personality**: Authoritative but friendly, wise but playful, professional courtroom judge meets enthusiastic food lover
- **Age/Experience**: Seasoned judge with countless food verdict under his belt
- **Role**: The ultimate food decision arbiter

---

## 🎭 **Character Design Specifications**

### **Base Anatomy**
```
     [Judge Wig/Cap]
         ____
        /    \
       (  👁👁  )  ← Expressive eyes (main emotion source)
       (  \_/  )  ← Simple mouth (changes per pose)
        \____/
           |
    [Arms] | [Gavel Body] 
      \_   |   _/
        \  |  /
         \ | /
          \|/
        -------
       /  ||  \
      /   ||   \   ← Gavel head (handle)
     /____|____\
```

### **Physical Characteristics**
- **Body**: Wooden gavel (mallet) - warm brown wood tone (#8B4513 to #D2691E)
- **Head**: The gavel head (hammer part) - slightly cartoonish, expressive
- **Arms**: Simple stick arms that can gesture
- **Legs**: Short stubby legs or just a base (optional)
- **Face**: Located on the gavel head
  - **Eyes**: Large, expressive cartoon eyes
  - **Mouth**: Simple line/curve that changes with emotion
  - **Eyebrows**: Optional - adds expression

### **Costume/Accessories**
- **Judge's Collar**: Small white collar or jabot (optional accent)
- **Judge's Wig**: Miniature white powdered wig (British style) OR small judge's cap
- **Gavel Handle**: Can be held or integrated into design

### **Color Palette**
```
Primary:
- Gavel Wood: #A0522D (Sienna) 
- Wood Highlight: #D2691E (Chocolate)
- Wood Shadow: #654321 (Dark Brown)

Accents:
- Judge Collar: #FFFFFF (White)
- Wig: #F5F5DC (Beige/Off-white)
- Eyes: #000000 (Black pupils), #FFFFFF (White sclera)
- Blush (when excited): #FF6B35 (Our primary orange!)
```

### **Size Variants**
All poses should be created in these sizes:
- **Small**: 60×60px base (for corner presence)
- **Medium**: 100×100px base (companion size)
- **Large**: 160×160px base (hero placement)
- **XLarge**: 220×220px base (splash/onboarding)

**Export**: PNG with transparency, @1x, @2x, @3x for iOS/Android

---

## 🎬 **The 10 Essential Poses**

### **1. IDLE** 🧍
**When Used**: Default state, home screen, waiting
**Description**: 
- Standing neutrally with slight smile
- Gavel at side or held loosely
- Relaxed, welcoming posture
- Eyes looking forward/slightly down
**Emotion**: Calm, ready, friendly
**Animation**: Gentle floating (translateY oscillation)

---

### **2. THINKING** 🤔
**When Used**: AI processing, 1 option added, deliberating
**Description**:
- Gavel held up to chin/mouth area
- Eyes looking up-left (thoughtful)
- One finger tapping gavel (optional)
- Slight tilt of head
**Emotion**: Contemplative, considering
**Animation**: Gentle head tilt oscillation

---

### **3. EXCITED** 🎉
**When Used**: 2+ options + objective selected, ready for verdict
**Description**:
- Gavel raised high above head
- Wide smile, eyes sparkling
- Slight bounce suggested in stance
- Energy lines/sparkles around gavel (optional)
**Emotion**: Enthusiastic, ready to decide!
**Animation**: Slight bounce or scale pulse

---

### **4. STERN** 👨‍⚖️
**When Used**: Validation errors, warnings, disapproval
**Description**:
- Arms crossed (gavel tucked under arm)
- Eyebrows down, serious mouth
- Standing very straight, authoritative
- Maybe a small warning icon nearby
**Emotion**: Serious, disappointed, authoritative
**Animation**: None (static for emphasis)

---

### **5. CONFUSED** 😕
**When Used**: Empty states, no options, unclear situation
**Description**:
- Head tilted significantly
- One hand scratching head/wig
- Eyes looking to the side with question marks
- Mouth in uncertain squiggle
- Gavel hanging down loosely
**Emotion**: Puzzled, uncertain, "what now?"
**Animation**: Slight head rotation

---

### **6. CELEBRATING** 🏆
**When Used**: After verdict reveal, success states
**Description**:
- Jumping in air (feet off ground)
- Both arms raised triumphantly
- Gavel held high
- Huge smile, closed happy eyes (^_^)
- Confetti or stars around (optional)
**Emotion**: Victorious, joyful, accomplished
**Animation**: Jump or scale bounce

---

### **7. SLEEPING** 😴
**When Used**: Empty history, no activity, late night
**Description**:
- Sitting or leaning
- Eyes closed with "zzz" bubbles
- Gavel resting beside
- Peaceful, gentle smile
- Maybe a small pillow or moon nearby
**Emotion**: Peaceful, resting, dormant
**Animation**: Gentle breathing (scale)

---

### **8. EATING** 🍕
**When Used**: During verdict explanation, food context
**Description**:
- Holding/munching on food item (slice of pizza, burger, etc.)
- Happy, content expression
- Eyes closed in enjoyment
- Tiny crumbs (optional)
- Gavel set down nearby
**Emotion**: Enjoying, savoring, delighted
**Animation**: Slight chewing motion (subtle)

---

### **9. POINTING** ☝️
**When Used**: Directing attention, explaining, tutorial
**Description**:
- One arm extended pointing to the right
- Gart looking in pointing direction
- Confident smile
- Other hand holding gavel at side
- Authority pose
**Emotion**: Directing, teaching, guiding
**Animation**: Arm slight emphasis pulse

---

### **10. WAVING** 👋
**When Used**: Splash screen, onboarding, greetings
**Description**:
- One arm raised in friendly wave
- Big welcoming smile
- Eyes wide and friendly
- Gavel in other hand
- Open, inviting posture
**Emotion**: Welcoming, friendly, "hello!"
**Animation**: Hand wave oscillation

---

## 📍 **Pose Usage Map (When Each Appears)**

### **Splash Screen**
- **Pose**: Waving
- **Size**: XLarge (220px)
- **Animation**: Bounces in from bottom

### **Home Screen**
- **Pose**: Idle
- **Size**: XLarge (220px)
- **Animation**: Floating (gentle up/down)
- **Context**: Main hero area

### **Home Screen (Empty State)**
- **Pose**: Confused
- **Size**: Medium (100px)
- **Animation**: None
- **Context**: Inside empty state card

### **New Decision Screen**
Initial:
- **Pose**: Confused (0 options)
- **Size**: Small (60px)

After 1 option:
- **Pose**: Thinking
- **Size**: Small (60px)

After 2+ options + objective:
- **Pose**: Excited
- **Size**: Small (60px)

### **Processing/Loading Screen**
- **Pose**: Thinking
- **Size**: Large (160px)
- **Animation**: Gavel tap rotation
- **Context**: Center screen while AI thinks

### **Verdict Screen**
Before reveal:
- **Pose**: Thinking
- **Size**: Large (160px)

After reveal:
- **Pose**: Celebrating
- **Size**: Large (160px)
- **Animation**: Jump/bounce with confetti

### **History Screen (Empty)**
- **Pose**: Sleeping
- **Size**: Medium (100px)
- **Context**: Empty state

### **Error States**
- **Pose**: Stern
- **Size**: Small (60px)
- **Context**: Error dialogs/snackbars

### **Onboarding**
Screen 1 - Welcome:
- **Pose**: Waving
- **Size**: Large (160px)

Screen 2 - How it Works:
- **Pose**: Pointing
- **Size**: Large (160px)

Screen 3 - Choose Personality:
- **Pose**: Idle (different expressions for each tone)
- **Size**: Medium (100px)

### **Settings Screen**
- **Pose**: Idle
- **Size**: Small (60px)
- **Context**: Corner mascot

---

## 🎨 **Art Style Guidelines**

### **Overall Style**
- **Genre**: Cute cartoon, flat design with subtle shading
- **Line Art**: Medium weight outlines (2-3px)
- **Shading**: Cel-shaded (flat colors with clear shadows)
- **Details**: Simple but expressive - not too complex

### **Emotion Expression Priorities**
1. **Eyes** - Main emotion driver (size, direction, shape)
2. **Mouth** - Secondary (simple curves/lines)
3. **Eyebrows** - Optional enhancement
4. **Body Language** - Pose supports emotional context

### **Consistency Rules**
- Keep same proportions across all poses
- Gavel should always be recognizable
- Color palette stays consistent
- Simple, bold shapes (think mobile-friendly)
- High contrast for visibility

### **Technical Requirements**
- **Format**: PNG with transparency
- **Background**: Fully transparent
- **Color Mode**: RGB
- **Resolution**: 
  - @1x (base sizes)
  - @2x (2× for retina)
  - @3x (3× for high-res)
- **Naming**: `judge_bite_[pose]_[size].png`
  - Example: `judge_bite_excited_large@3x.png`

---

## 💬 **Personality Traits (For Context)**

### **Voice/Tone Options** (affects text, not visuals)
Users can choose Judge Bite's speaking style:

1. **Stern**: "The court has reached a decision."
2. **Sassy**: "Oh honey, this is EASY."
3. **Enthusiastic**: "OMG THIS IS AMAZING!"
4. **Chill**: "Yeah, I got you..."

**Note**: Visuals stay the same - tone only affects written verdicts

---

## 📦 **Deliverables Checklist**

For each of the 10 poses:
- [ ] Concept sketch showing pose and emotion
- [ ] Flat color version
- [ ] Final shaded version
- [ ] Exported @1x, @2x, @3x for each size (S, M, L, XL)
- [ ] Organized in folders: `assets/images/judge_bite/[pose]/`

**Total Files**: 10 poses × 4 sizes × 3 resolutions = **120 PNG files**

---

## 🎬 **Animation Notes** (For Future)

While we'll start with static poses that transition:

### **Future Enhancement Ideas**
- **Idle breathing**: Subtle scale oscillation
- **Thinking tap**: Gavel tapping animation
- **Excited bounce**: Spring scale animation
- **Wave hand**: Actual waving motion
- **Eating munch**: Subtle chewing
- **Confetti burst**: Particle effect on celebrating

**Current**: Simple pose transitions with fade/scale (300ms, elasticOut curve)

---

## 🖼️ **Example Mood Board References**

Think of these vibes:
- **Character Style**: Judge from "Ace Attorney" meets "Clippy" 
- **Cuteness Level**: Duolingo Owl meets Animal Crossing
- **Expressiveness**: Pixar-level emotion in simple shapes
- **Professionalism**: Courtroom authority but approachable
- **Food Love**: Ratatouille's passion meets judge's gravitas

---

## 📝 **Priority Order for Creation**

If creating incrementally, prioritize:
1. **Idle** - Used everywhere as default
2. **Confused** - Empty states (critical for UX)
3. **Excited** - Positive feedback (user engagement)
4. **Thinking** - Processing/loading (AI context)
5. **Celebrating** - Verdict reveal (climax moment)
6. **Waving** - Onboarding (first impression)
7. **Pointing** - Tutorial (guidance)
8. **Stern** - Errors (less common)
9. **Sleeping** - Empty history (nice-to-have)
10. **Eating** - Contextual delight (nice-to-have)

---

## 🎨 **Quick Style Sheet**

```css
Judge Bite Visual DNA:
├─ Body: Wooden gavel (warm browns)
├─ Face: Simple, expressive (large eyes)
├─ Costume: Subtle judge accents (collar/wig)
├─ Style: Flat cartoon, cel-shaded
├─ Line Weight: 2-3px outlines
└─ Emotion: Eyes > Mouth > Body Language
```

---

## 🚀 **Current Implementation Status**

**Phase 3 (Completed)**:
- Using placeholder icons (gavel, pending, celebration, etc.)
- Pose switching works (confused → thinking → excited)
- Floating animation implemented
- Size system implemented

**Phase 4 (Next)**:
- Replace placeholders with actual Judge Bite graphics
- Add more personality to transitions
- Implement verdict celebration

**Ready for**: Asset creation! 🎨

---

**This specification should give your artist/designer everything needed to create consistent, expressive Judge Bite mascot graphics!** ⚖️✨

Need any clarification on specific poses or technical requirements? Let me know!
