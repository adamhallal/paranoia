import SwiftUI
import SwiftData

struct PackSelectionView: View {
    let players: [Player]

    @Query private var allPacks: [QuestionPack]
    @State private var selectedPackIDs: Set<UUID> = []
    @State private var gameSession: GameSession?

    private var availablePacks: [QuestionPack] {
        allPacks.filter { !$0.questions.isEmpty }
    }

    private var canStart: Bool {
        !selectedPackIDs.isEmpty
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Pick Your Packs")
                    .font(.title.weight(.bold))
                    .foregroundColor(.white)

                Text("Select one or more question packs")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(availablePacks) { pack in
                            let isSelected = selectedPackIDs.contains(pack.id)
                            Button {
                                if isSelected {
                                    selectedPackIDs.remove(pack.id)
                                } else {
                                    selectedPackIDs.insert(pack.id)
                                }
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(pack.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text("\(pack.questions.count) questions")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(isSelected ? .purple : .gray)
                                        .font(.title2)
                                }
                                .padding(16)
                                .background(isSelected ? Color.purple.opacity(0.15) : Color.white.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }

                if availablePacks.isEmpty {
                    VStack(spacing: 8) {
                        Text("No question packs available")
                            .foregroundColor(.gray)
                        Text("Go back and create some in Question Packs")
                            .font(.caption)
                            .foregroundColor(.gray.opacity(0.7))
                    }
                    .frame(maxHeight: .infinity)
                }

                Spacer()

                Button {
                    startGame()
                } label: {
                    Text("Let's Go!")
                        .font(.title3.weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            canStart
                                ? AnyShapeStyle(LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing))
                                : AnyShapeStyle(Color.gray.opacity(0.3))
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(!canStart)
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
            }
            .padding(.top, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $gameSession) { session in
            GameView(session: session)
        }
    }

    private func startGame() {
        let selectedQuestions = allPacks
            .filter { selectedPackIDs.contains($0.id) }
            .flatMap { $0.questions }

        gameSession = GameSession(players: players, questions: selectedQuestions)
    }
}
