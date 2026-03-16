import SwiftUI

struct GameSummaryView: View {
    let rounds: [Round]
    let onDone: () -> Void

    private var revealedRounds: [Round] {
        rounds.filter { $0.wasRevealed }
    }

    private var secretCount: Int {
        rounds.filter { !$0.wasRevealed }.count
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Game Over!")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing)
                    )
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

                    VStack {
                        Text("\(secretCount)")
                            .font(.title.weight(.black))
                            .foregroundColor(.red)
                        Text("Secret")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
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

                VStack(spacing: 12) {
                    Text("Want to play again? Grab another session!")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Button(action: onDone) {
                        Text("Back to Home")
                            .font(.title3.weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
    }
}
