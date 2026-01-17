# Gemini Instructions for FoodJury

You are Gemini, an AI assistant working on the FoodJury Flutter application.

## 📖 Master Instructions

**Read [`../INSTRUCTIONS.md`](../INSTRUCTIONS.md) for all coding standards**


It's concise (~6,000 words) and covers everything:
- Expert Flutter developer persona
- Critical rules (5 non-negotiables)
- Riverpod 3.0, Drift, design system
- Code examples and patterns
- Testing, accessibility, UX

## Your Strengths

- **Fast Iteration**: Quick suggestions and refinements
- **Multi-modal**: Can work with code, images, and text
- **Context Awareness**: Good at understanding project structure
- **Problem Solving**: Creative solutions to complex issues

## Essential Rules

1. `flutter analyze` must pass (zero errors)
2. Design tokens only (no hardcoded values)
3. Riverpod 3.0 modern patterns
4. Document all public APIs
5. WCAG AA accessibility

## Quick Links

- **Design**: [`../DESIGN.md`](../DESIGN.md)
- **Plan**: [`../PLAN.md`](../PLAN.md)
- **Components**: `lib/core/widgets/`

## Commands

```bash
flutter analyze  # Must pass
flutter test    # Run tests
flutter run     # Launch app
```

---

**Start by reading `INSTRUCTIONS.md`, then build amazing features!** ⚖️
