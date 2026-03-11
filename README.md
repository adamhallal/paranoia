# Paranoia

A party game for iPhone built with SwiftUI. Based on the classic **Paranoia** drinking/party game where secrets are whispered, names are said out loud, and a coin flip decides if the truth comes out.

## How It Works

1. **Gather your friends** (3+ players) and open the app
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
  - **Starter** (Free) — 5 demo questions to get started
  - **Spicy** ($2.99/session) — bold and daring questions to turn up the heat (10 random from 20)
  - **Party** ($2.99/session) — fun and wild questions perfect for any group (10 random from 20)
  - **Couple** ($2.99/session) — intimate questions for you and your partner (10 random from 20)
- **In-App Purchases** — buy play sessions for premium packs via StoreKit 2
- **Exit anytime** — leave a game mid-round with a clear warning about losing progress
- **Game summary** — end-of-game recap showing revealed vs. secret questions
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
├── ParanoiaApp.swift              # App entry point & SwiftData container
├── Models/
│   ├── Player.swift               # Player (name, id)
│   ├── Question.swift             # Question model (SwiftData)
│   ├── QuestionPack.swift         # Question pack model (SwiftData)
│   ├── Round.swift                # Single round result (player, question, revealed)
│   └── GameSession.swift          # Game state manager (Observable)
├── Views/
│   ├── HomeView.swift             # Main menu
│   ├── PlayerSetupView.swift      # Add/remove players
│   ├── PackSelectionView.swift    # Choose question packs
│   ├── GameView.swift             # Core game loop (5 phases)
│   ├── CoinFlipView.swift         # Animated coin flip
│   ├── RoundResultView.swift      # Revealed/secret result screen
│   ├── GameSummaryView.swift      # End-of-game recap
│   └── QuestionPackManagerView.swift  # Browse & purchase packs
├── Store/
│   ├── StoreManager.swift         # StoreKit 2 purchase & credit management
│   └── PackPurchaseView.swift     # Purchase sheet UI
├── Data/
│   ├── DefaultQuestions.swift     # Premium question packs
│   └── DemoQuestions.swift        # Free Starter pack
├── Configuration/
│   └── ParanoiaProducts.storekit  # StoreKit testing config
└── Utilities/
    └── HapticManager.swift        # Haptic feedback helpers
```

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

2. Open `Paranoia.xcodeproj` in Xcode

3. Build and run on an iPhone simulator or device (iOS 17+) with **Cmd+R**

## Game Flow

```
Home Screen
    │
    ├── Start Game
    │       │
    │       ▼
    │   Player Setup (add 3+ names)
    │       │
    │       ▼
    │   Pack Selection (pick a pack)
    │       │
    │       ▼
    │   ┌─────────────────────────┐
    │   │  GAME LOOP              │
    │   │                         │
    │   │  Pass Phone → Question  │
    │   │       → Answer Out Loud │
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

## License

This project is for personal/educational use.

## Acknowledgments

Built with SwiftUI and a healthy dose of paranoia.
