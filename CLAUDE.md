# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

blockTracker is an iOS climbing/bouldering tracker app built with SwiftUI and SwiftData. It helps climbers track their boulder problems (blocs), sessions, progression statistics, and unlock achievement badges.

## Build & Run

This is a standard Xcode project. Open `blockTracker.xcodeproj` in Xcode and build/run normally.
- No external dependencies or package managers (no CocoaPods, SPM, or Carthage)
- Target: iOS 17+ (uses SwiftData and @Observable macro)
- Use Xcode's built-in simulator or device deployment

## Architecture

### Data Layer (SwiftData)

The app uses SwiftData for persistence with two main `@Model` classes:

**SessionModel** (`Models/sessionModel.swift`)
- Represents a climbing session with a date and collection of blocs
- Contains computed properties for session statistics (score, min/max/average level, completion rate, etc.)
- Has a cascade delete relationship with BlocModel

**BlocModel** (`Models/blocModel.swift`)
- Represents a single boulder problem with: level (difficulty), completed status, attempts, overhang flag
- Parent relationship to SessionModel
- Contains **sophisticated score calculation logic** (`calculateBlocScore()`) that:
  - Uses exponential difficulty scaling based on level
  - Applies style multipliers (1.25x for overhang)
  - Rewards completion with 20% bonus + efficiency bonus for fewer attempts
  - For failed attempts, awards 30% base + 5% per attempt (capped at 80% of raw score)

**UnlockedBadgeModel** (`Models/UnlockedBadgeModel.swift`)
- Stores unlocked achievement badges with badgeId and unlockDate
- Persisted via SwiftData

### State Management

**AppState** (`State/AppState.swift`)
- `@Observable` class for global app state
- Manages `selectedTab` and `sessionToShow` for navigation
- Injected via `.environment()` modifier

### Badge System

The badge system is split into multiple files in `Badges/`:

- **BadgeModel.swift**: Defines `Badge` struct (id, name, description, icon, category, condition closure) and `BadgeCategory` enum
- **BadgesRegistry.swift**: Central registry combining all badge arrays and providing lookup methods
- **SessionBadges.swift**, **BlocBadges.swift**, **PerformanceBadges.swift**: Category-specific badge definitions as `Badge` extensions

**BadgeService** (`Services/BadgeService.swift`)
- Takes ModelContext in initializer
- `checkAndUnlockBadges(stats:)` evaluates all badges against GlobalStatsData, persists newly unlocked ones
- Uses `BadgeRegistry.allBadges` to iterate through all available badges

### Statistics

**GlobalStatsData** (`Models/GlobalStatsData.swift`)
- Struct containing aggregated stats: total sessions, average score/level, success rate, max level, overhang ratio, flash count, etc.
- Includes `Set<Int>` for completed/flashed/overhang levels (used for badge conditions)
- Contains chart data arrays (`scoreHistory`, `levelHistory`)

**StatsService** (`Services/StatsService.swift`)
- Static `computeStats(from:)` method that aggregates all sessions into GlobalStatsData
- Flattens all blocs from all sessions to calculate global metrics
- Generates time-series data for charts

### Views Structure

**MainTabView** (`Views/MainTabView.swift`)
- Root TabView with 4 tabs: Stats, Journal (Sessions), Grimper (Active), Trophées (Badges)
- Custom UITabBarAppearance for dark glass-effect styling
- Uses `.tint(Color.climbingAccent)` for neon accent color

**Key Views:**
- `StatsView`: Displays global statistics and charts
- `SessionListView`: History of past sessions
- `ActiveSessionView`: Active climbing session interface
- `BadgesListView`: Shows unlocked and locked badges
- `SessionDetailView`: Detail view for individual session
- `BadgeDetailSheet`: Sheet presentation for badge details

**Components** (`Components/`):
- Reusable UI components: `BlocCard`, `BlocEditableCard`, `SessionCard`, `BadgeItemView`, `NewBadgePopup`, `EvolutionChart`, etc.

### Theme

**Theme.swift** (`Theme/Theme.swift`)
- Custom colors: `.cardBackground` (dark card bg), `.climbingAccent` (neon yellow-green), `.textSecondary`
- Custom font helpers: `.fitness(_:weight:)` for TextStyle or `.fitness(size:weight:)` for specific sizes
- Uses `.rounded` font design throughout

### App Entry

**blockTrackerApp.swift**
- Sets up `.modelContainer(for: [SessionModel.self, BlocModel.self])`
- ContentView wraps MainTabView

## Key Patterns

1. **SwiftData Relationships**: SessionModel owns BlocModel with cascade delete. Always create BlocModel with a parent SessionModel.

2. **Score Calculation**: BlocModel.score is computed, not stored. The formula is complex and balances difficulty, style, completion, and efficiency. Don't modify casually.

3. **Badge Unlocking Flow**:
   - Compute GlobalStatsData via StatsService
   - Pass to BadgeService.checkAndUnlockBadges()
   - Returns newly unlocked badges (show popup via NewBadgePopup)
   - Already unlocked badges are fetched from SwiftData to avoid re-unlocking

4. **State Injection**: AppState is injected at MainTabView level via `.environment()`. Views access it via `@Environment(AppState.self)`.

5. **Preview Data**: `Models/Helpers/PreviewData.swift` contains `previewContainer` for SwiftUI previews. Use this in `#Preview` blocks.

6. **French UI**: The app UI is in French (e.g., "Grimper", "Journal", "Trophées"). Maintain this convention.

## Important Conventions

- **Model Persistence**: BlocModel must always be created with a parent SessionModel. Don't orphan blocs.
- **Badge Conditions**: Badge condition closures receive GlobalStatsData. Use the provided sets (completedLevels, flashedLevels, overhangLevels) for level-based achievements.
- **Theming**: Use `Color.climbingAccent` for primary actions, `.cardBackground` for cards, `.fitness()` fonts for consistency.
- **Previews**: Always provide SwiftUI previews with `previewContainer` for views that use SwiftData.
