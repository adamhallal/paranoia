import SwiftUI

struct GameSummaryView: View {
    let rounds: [Round]
    let onDone: () -> Void

    private var revealedRounds: [Round] {
        rounds.filter { $0.wasRevealed }
    }

    private var secretCount: Int {
        rounds.count - revealedRounds.count
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Game Over!")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(Theme.primaryGradient)
                    .padding(.top, 40)

                Text("\(rounds.count) rounds played")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                HStack(spacing: 32) {
                    VStack {
                        Text("\(revealedRounds.count)")
                            .font(.title.weight(.black))
                            .foregroundColor(.green)
                        Text("Revealed")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(revealedRounds.count) revealed")

                    VStack {
                        Text("\(secretCount)")
                            .font(.title.weight(.black))
                            .foregroundColor(.red)
                        Text("Secret")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(secretCount) secret")
                }
                .padding(.vertical, 8)

                if !revealedRounds.isEmpty {
                    Text("Revealed Questions")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)

                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(revealedRounds) { round in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(round.askedPlayer.name)
                                        .font(.caption.weight(.bold))
                                        .foregroundColor(.purple)

                                    Text(round.question.text)
                                        .font(.body)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(14)
                                .background(Color.white.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }

                if secretCount > 0 {
                    Text("\(secretCount) questions remain a mystery...")
                        .font(.subheadline)
                        .foregroundColor(.pink)
                        .italic()
                }

                Spacer()

                VStack(spacing: 12) {
                    Text("Want to play again? Grab another session!")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Button(action: onDone) {
                        Text("Back to Home")
                            .primaryButtonStyle()
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    GameSummaryView(
        rounds: [
            Round(askedPlayer: Player(name: "Alex"), question: Question(text: "Who is most likely to cry at a movie?"), wasRevealed: true),
            Round(askedPlayer: Player(name: "Jordan"), question: Question(text: "Who gives the best hugs?"), wasRevealed: false),
        ]
    ) {}
}
