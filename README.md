# Paranoia

A party game for iPhone built with SwiftUI. Based on the classic **Paranoia** drinking/party game where secrets are whispered, names are said out loud, and a coin flip decides if the truth comes out.

## How It Works

1. **Gather your friends** (3–10 players) and open the app
2. **Pick a question pack** — choose from the free Starter pack or purchase a premium pack
3. **Pass the phone** — the screen tells you who gets it next
4. **Read the question** — only the person holding the phone sees it (e.g., *"Who is most likely to cry at a movie?"*)
5. **Say a name out loud** — answer the question by saying someone's name for everyone to hear
6. **Flip the coin** — this is where the paranoia kicks in:
   - **Heads**: The question is revealed to everyone
   - **Tails**: The question stays a secret — everyone heard the name, but nobody knows *why*
7. **Repeat** until you run out of questions (or trust)

## Screenshots

*Coming soon*

## Features

- **Classic Paranoia gameplay** — faithful to the original party game
- **Pass-the-phone multiplayer** — no wifi, no accounts, no friction
- **Privacy screen** — prevents others from seeing the question during handoff
- **Coin flip animation** — 3D rotation with haptic feedback
- **Question Packs**:
  - **Starter** (Free) — 10 demo questions to get started
  - **Spicy** ($2.99/session) — flirting, exes, and juicy confessions
  - **Party** ($2.99/session) — embarrassing moments and hilarious callouts
- **In-App Purchases** — buy play sessions for premium packs via StoreKit 2
- **Exit anytime** — leave a game mid-round with a clear warning about losing progress
- **Suggest Questions** — users can suggest new questions or packs from the Question Packs screen
- **Game summary** — end-of-game recap showing revealed vs. secret questions
- **Auto-updating packs** — question pack content updates automatically when a new version is available
- **Dark mode UI** — purple/pink gradient theme designed for evening hangouts

## Tech Stack

| Component | Technology |
|-----------|------------|
| UI Framework | SwiftUI |
| Persistence | SwiftData |
| In-App Purchases | StoreKit 2 |
| Target | iOS 17+ |
| Language | Swift 5.9+ |
| IDE | Xcode 15+ |

## Project Structure

```
paranoia/
├── ParanoiaApp.swift              # App entry point & SwiftData container setup
├── Assets.xcassets/               # Asset catalog (app icon, etc.)
│   └── AppIcon.appiconset/        # 1024x1024 app icon (single-image format)
├── PrivacyInfo.xcprivacy          # Privacy manifest (UserDefaults declaration)
├── Models/
│   ├── Player.swift               # Player struct (name, id)
│   ├── Question.swift             # Question model (SwiftData, stores question text)
│   ├── QuestionPack.swift         # Pack model (SwiftData, owns questions, tracks version)
│   ├── Round.swift                # Single round result (who was asked, what, revealed?)
│   └── GameSession.swift          # Observable game state (players, rounds, question queue)
├── Views/
│   ├── HomeView.swift             # Main menu — "Start Game" and "Question Packs" buttons
│   ├── PlayerSetupView.swift      # Add/remove players (3–10), name validation
│   ├── PackSelectionView.swift    # Pick a pack to play, shows credits, starts game
│   ├── GameView.swift             # Core game loop controller (pass → question → flip → result)
│   ├── CoinFlipView.swift         # Animated 3D coin flip with haptic feedback
│   ├── RoundResultView.swift      # Shows revealed question or "secret" message
│   ├── GameSummaryView.swift      # End-of-game recap (revealed vs. secret stats)
│   └── QuestionPackManagerView.swift  # Browse all packs, purchase, suggest questions
├── Store/
│   ├── StoreManager.swift         # StoreKit 2 IAP, credit system (UserDefaults), transaction listener
│   └── PackPurchaseView.swift     # Purchase sheet for a single premium pack
├── Data/
│   ├── DefaultQuestions.swift     # Premium pack definitions (Party, Spicy)
│   └── DemoQuestions.swift        # Free Starter pack definition
├── Configuration/
│   └── ParanoiaProducts.storekit  # StoreKit testing configuration
└── Utilities/
    ├── HapticManager.swift        # Cached haptic feedback generators (heavy/light)
    └── Theme.swift                # Shared constants, gradient, button style, section header
```

### Key Files Explained

| File | What it does | When you'd edit it |
|------|-------------|-------------------|
| `ParanoiaApp.swift` | Creates the SwiftData container, auto-inserts/updates packs on launch | Adding new models or changing pack seeding logic |
| `GameSession.swift` | Holds all runtime game state — player rotation, question queue, round history | Changing game rules (e.g. turn order, win conditions) |
| `QuestionPack.swift` | SwiftData model with `packDescription` and `detailedDescription` computed properties | Adding pack metadata or changing the data schema |
| `Theme.swift` | `PrimaryButtonStyle` modifier, `SectionHeader` view, `primaryGradient`, and constants (`premiumQuestionsPerSession`, `maxNameLength`) | Changing app-wide styling or shared constants |
| `StoreManager.swift` | Manages products, purchases, and a per-pack credit system stored in UserDefaults | Changing pricing, credit logic, or adding new IAP products |
| `DefaultQuestions.swift` | Where premium pack questions live — bump `version` after editing to trigger updates for existing users | Adding/changing questions in premium packs |
| `DemoQuestions.swift` | Same as above but for the free Starter pack | Adding/changing free questions |

## Getting Started

### Prerequisites

- macOS with **Xcode 15+** installed
- iOS 17+ simulator or physical iPhone

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/adamhallal/paranoia.git
   cd paranoia
   ```

2. Open `paranoia.xcodeproj` in Xcode

3. Build and run on an iPhone simulator or device (iOS 17+) with **Cmd+R**

## Game Flow

```
Home Screen
    │
    ├── Start Game
    │       │
    │       ▼
    │   Player Setup (add 3–10 names)
    │       │
    │       ▼
    │   Pack Selection (pick a pack)
    │       │
    │       ▼
    │   ┌─────────────────────────┐
    │   │  GAME LOOP              │
    │   │                         │
    │   │  Pass Phone → Question  │
    │   │       → Coin Flip       │
    │   │       → Reveal/Secret   │
    │   │       → Next Player ──┐ │
    │   │            ▲          │ │
    │   │            └──────────┘ │
    │   └───────────┬─────────────┘
    │               │ (out of questions)
    │               ▼
    │         Game Summary
    │               │
    │               ▼
    │           Back to Home
    │
    └── Question Packs
            │
            ├── View available packs
            └── Purchase premium packs
```

## Updating Question Packs

Each question pack has a `version` number. To update a pack's content:

1. Edit the questions in `DemoQuestions.swift` (Starter) or `DefaultQuestions.swift` (premium packs)
2. Bump the `version` parameter on that pack (e.g., `version: 2` → `version: 3`)

On next launch, the app compares each bundled pack's version against the stored version. If the bundled version is higher, the old questions are replaced with the new ones automatically.

## License

This project is for personal/educational use.

## Acknowledgments

Built with SwiftUI and a healthy dose of paranoia.
