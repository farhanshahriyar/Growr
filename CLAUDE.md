# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Growr** is a Flutter mobile app for Bangladeshi users who want to follow a lean bulk plan using affordable local food and a realistic daily routine. The app focuses on discipline, consistency, and low-friction daily tracking.

**Core Daily Goals**: Hit calorie targets, hit protein targets, complete workouts, track water intake.

**Key Principles**:
- Local-first, budget-conscious design
- Manual logging is primary (food scan deferred)
- Fast, simple daily workflows (meals in under 10 seconds)
- Realistic Bangladeshi food examples (rice, dal, roti, eggs, fish, milk, banana, chola, soy chunks)
- Calm, authoritative UI (Material 3, teal/sage palette, no aggressive fitness tropes)

## Tech Stack

- Flutter 3.3+ (SDK >=3.3.0 <4.0.0)
- Dart
- Material 3 design system
- go_router for navigation
- flutter_riverpod for state management
- drift + sqlite for local persistence
- shared_preferences for small flags
- uuid for IDs
- google_fonts for Inter font

## Architecture

### Feature-First Structure

```
lib/
├── app/                    # App-level configuration
│   ├── app.dart           # GrowrApp root widget
│   ├── router.dart        # go_router with auth guard
│   └── theme/             # Material 3 theme tokens
├── core/domain/           # Shared domain models (UserProfile)
├── data/
│   ├── local/
│   │   ├── db/            # Drift database, tables, seed data
│   │   └── seed/          # Seed foods and workouts
│   └── repositories/      # Repository implementations
├── features/              # Feature modules
│   ├── onboarding/
│   ├── home/
│   ├── meals/
│   ├── workout/
│   ├── hydration/
│   ├── progress/
│   └── profile/
└── shared/widgets/        # Reusable UI components
```

### Navigation

- `ShellRoute` with bottom navigation bar (Home, Meals, Workout, Progress)
- Onboarding is guarded: no UserProfile → redirect to `/onboarding`
- Completed onboarding → redirect to `/home`

### State Management with Riverpod

Common patterns:
- **StreamProvider**: Reactive data streams (e.g., `profileProvider`, `todayMealsProvider`, `activeWorkoutSessionProvider`)
- **Provider**: Computed values or controllers (e.g., `homeControllerProvider`, `todayMealsTotalsProvider`)
- **NotifierProvider**: Action controllers (e.g., `profileControllerProvider`)

Controllers encapsulate business logic and expose methods like `logFood`, `addWater`, `startWorkout`, etc.

### Data Layer (Drift)

- Database: `AppDatabase` in `lib/data/local/db/app_database.dart`
- Tables defined in `tables/` with `@DataClassName` entities
- Seed data inserted on first launch (`onCreate`)
- Repositories expose Streams for reactive queries and simple Futures for writes
- `databaseProvider` gives singleton database instance

## Commands

```bash
# Get dependencies
flutter pub get

# Run the app (device/emulator required)
flutter run

# Build APK (Android)
flutter build apk

# Build app bundle (Play Store)
flutter build appbundle

# Analyze code
flutter analyze

# Format code
flutter format .

# Run tests (none yet)
flutter test

# Generate Drift code after table schema changes
flutter pub run build_runner build
```

## Design System (from DESIGN.md)

- Material 3 with custom theme tokens (AppTheme, AppColors, AppTypography)
- **Primary**: Teal (#006D77), **Secondary**: Sage (#83C5BE)
- **The "No-Line" Rule**: Use background color shifts (`surface` → `surface-container-low` → `surface-container-lowest`) instead of borders
- **Elevation**: Stack surface containers; use ambient shadows (6% opacity, 24-32px blur) sparingly
- **Typography**: Inter font; breathable line heights; editorial hierarchy
- **Components**: Rounded corners (16px), no divider lines, progress rings with gradient optional

## Implementation Status (by Phase)

- ✅ Phase 1 — Foundation (router, theme, widgets, bottom nav)
- ✅ Phase 2 — Onboarding + Profile (onboarding flow, profile guard, local profile save)
- ✅ Phase 3 — Local database (Drift setup, core tables, seed foods/workouts, repository layer)
- ✅ Phase 4 — Meals (quick-add, search, logging, daily totals)
- ✅ Phase 5 — Workout (5-day plans, session tracking, set logging)
- ✅ Phase 6 — Water (hydration card with add modal, 1 glass = 250ml)
- ✅ Phase 7 — Progress (weekly summaries, weight history, photo placeholders)
- Deferred — Phase 8 — Scan prototype (camera placeholder, barcode scan)
- Deferred — Phase 9 — Backend (Supabase auth + sync)

## Key Files and Responsibilities

- `lib/main.dart` → Entry point, ProviderScope
- `lib/app/router.dart` → go_router config, profile guard
- `lib/data/local/db/app_database.dart` → Drift database definition with migrations
- `lib/data/repositories/*.dart` → Repositories for each domain
- Features:
  - meals: `meals_controller.dart` (providers + actions), `meals_screen.dart`
  - workout: `workout_controller.dart`, `workout_screen.dart`
  - hydration: `hydration_controller.dart` (actions only)
  - progress: `progress_controller.dart`, `progress_screen.dart`
  - home: `home_controller.dart` (orchestrates other providers), `home_screen.dart`
  - onboarding: `onboarding_controller.dart`, step widgets

## Development Workflow

1. All new features should follow the feature-first structure (domain, application, presentation).
2. Keep business logic in Riverpod controllers/providers, UI in presentation widgets.
3. Controllers should be thin; use derived providers for computed state where possible.
4. Drift writes use Companion classes; reads return domain entities.
5. Seed data should reflect Bangladeshi affordable foods and 5-day workout split.
6. UI must respect the design system: no 1px borders, use surface containers for depth, calm copy tone.

## Known Constraints

- Water conversion: **1 glass = 250ml** (10 glasses = 2.5L)
- Default foods: eggs, rice, dal, roti, milk, banana, fish, chola, soy chunks, vegetables.
- Workout plans: 5-day split (Day 1 Upper Push, Day 2 Upper Pull, Day 3 Lower, Day 4 Shoulders, Day 5 Full Body)
- Copy tone: practical, calm, grounded. No fake expert personas.
- Food scan is deferred; any scan UI must require manual confirmation.

## Backend Status

MVP is local-only using Drift/SQLite. Supabase (auth + cloud sync) is not implemented and should not be added until all core offline flows are stable.

## Notes for Future Work

- Add proper error handling and user feedback (e.g., SnackBars for actions)
- Replace hard-coded day names with localizations if needed
- Implement weight chart using fl_chart
- Add water quick-add chips on hydration card instead of modal
- Add progress photo upload with image_picker and file storage
- Write unit and widget tests
- Consider separating daily totals into separate providers to avoid full rebalances

---

*This CLAUDE.md was generated to capture the final state of the Growr MVP implementation (Phases 1–7).*
