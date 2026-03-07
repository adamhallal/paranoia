# Paranoia

A party game for iPhone built with SwiftUI. Based on the classic **Paranoia** drinking/party game where secrets are whispered, names are said out loud, and a coin flip decides if the truth comes out.

## How It Works

1. **Gather your friends** (3+ players) and open the app
2. **Pick question packs** — choose from pre-built packs or create your own
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
- **3 pre-built question packs**:
  - **Party** — lighthearted group fun (20 questions)
  - **Spicy** — edgier, more personal (20 questions)
  - **Chill** — low-stakes, wholesome (20 questions)
- **Custom question packs** — create, edit, and save your own packs
- **Game summary** — end-of-game recap showing revealed vs. secret questions
- **Dark mode UI** — purple/pink gradient theme designed for evening hangouts

## Tech Stack

| Component | Technology |
|-----------|------------|
| UI Framework | SwiftUI |
| Persistence | SwiftData |
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
│   ├── Round.swift                # Single round result
│   └── GameSession.swift          # Game state manager (Observable)
├── Views/
│   ├── HomeView.swift             # Main menu
│   ├── PlayerSetupView.swift      # Add/remove players
│   ├── PackSelectionView.swift    # Choose question packs
│   ├── GameView.swift             # Core game loop (5 phases)
│   ├── CoinFlipView.swift         # Animated coin flip
│   ├── RoundResultView.swift      # Revealed/secret result screen
│   ├── GameSummaryView.swift      # End-of-game recap
│   └── QuestionPackManagerView.swift  # Create/edit custom packs
├── Data/
│   └── DefaultQuestions.swift     # Pre-built question packs
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

2. Open Xcode and create a new iOS App project:
   - **Product Name**: paranoia
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Storage**: None (SwiftData is configured in code)

3. Replace the generated source files with the files from this repo's `paranoia/` directory

4. Build and run on an iPhone simulator or device (iOS 17+)

### Alternative: Quick Xcode Setup

1. In Xcode: **File → New → Project → iOS → App**
2. Save the `.xcodeproj` inside the cloned repo's `paranoia/` folder
3. Drag all `.swift` files into the Xcode project navigator
4. Hit **Cmd+R** to build and run

## Game Flow Diagram

```
Home Screen
    │
    ├── Start Game
    │       │
    │       ▼
    │   Player Setup (add 3+ names)
    │       │
    │       ▼
    │   Pack Selection (pick 1+ packs)
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
            ├── View built-in packs
            ├── Create custom pack
            └── Edit/delete custom packs
```

## Customization

### Adding New Question Packs

Edit `Data/DefaultQuestions.swift` to add more built-in packs:

```swift
static func myPack() -> QuestionPack {
    QuestionPack(name: "My Pack", questions: [
        Question(text: "Who is most likely to...?"),
        // Add more questions
    ])
}
```

Then add it to `allPacks()`:
```swift
static func allPacks() -> [QuestionPack] {
    [partyPack(), spicyPack(), chillPack(), myPack()]
}
```

Players can also create custom packs directly in the app — these are saved locally using SwiftData.

## License

This project is for personal/educational use.

## Acknowledgments

Built with SwiftUI and a healthy dose of paranoia.
