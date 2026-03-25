import SwiftUI
import SwiftData

struct PackSelectionView: View {
    let players: [Player]

    @Query private var allPacks: [QuestionPack]
    @Environment(StoreManager.self) private var storeManager
    @State private var selectedPackID: UUID?
    @State private var gameSession: GameSession?
    @State private var purchasePack: QuestionPack?
    @State private var lastPurchasePack: QuestionPack?
    @State private var showCreditsAlert = false

    private var freePacks: [QuestionPack] {
        allPacks.filter { !$0.isPremium && !$0.questions.isEmpty }
    }

    private var premiumPacks: [QuestionPack] {
        allPacks.filter { $0.isPremium && !$0.questions.isEmpty }
            .sorted { QuestionPack.premiumOrder.firstIndex(of: $0.name) ?? 99 < QuestionPack.premiumOrder.firstIndex(of: $1.name) ?? 99 }
    }

    private var canStart: Bool {
        selectedPackID != nil
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Pick a Pack")
                    .font(.title.weight(.bold))
                    .foregroundColor(.white)

                Text("Choose a question pack to play")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                ScrollView {
                    LazyVStack(spacing: 12) {
                        if !freePacks.isEmpty {
                            SectionHeader(title: "FREE")
                            ForEach(freePacks) { pack in
                                packRow(pack: pack, isFree: true)
                            }
                        }

                        if !premiumPacks.isEmpty {
                            SectionHeader(title: "PREMIUM")
                                .padding(.top, 8)
                            ForEach(premiumPacks) { pack in
                                packRow(pack: pack, isFree: false)
                            }
                        }

                    }
                    .padding(.horizontal, 24)
                }

                if freePacks.isEmpty && premiumPacks.isEmpty {
                    VStack(spacing: 8) {
                        Text("No question packs available")
                            .foregroundColor(.gray)
                        Text("Packs are added on first launch")
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
                        .primaryButtonStyle(isEnabled: canStart)
                }
                .disabled(!canStart)
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
            .padding(.top, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $gameSession) { session in
            GameView(session: session)
                .environment(storeManager)
        }
        .sheet(item: $purchasePack, onDismiss: {
            if let pack = lastPurchasePack, let productID = pack.productID, storeManager.credits(for: productID) > 0 {
                selectedPackID = pack.id
            }
            lastPurchasePack = nil
        }) { pack in
            PackPurchaseView(pack: pack)
                .environment(storeManager)
                .onAppear { lastPurchasePack = pack }
        }
        .alert("No Credits", isPresented: $showCreditsAlert) {
            Button("OK") {}
        } message: {
            Text("You need to purchase a session for this premium pack before playing.")
        }
    }

    @ViewBuilder
    private func packRow(pack: QuestionPack, isFree: Bool) -> some View {
        let isSelected = selectedPackID == pack.id
        let credits = pack.productID.map { storeManager.credits(for: $0) } ?? 0
        let isLocked = pack.isPremium && credits == 0

        Button {
            if isLocked {
                purchasePack = pack
            } else if isSelected {
                selectedPackID = nil
            } else {
                selectedPackID = pack.id
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(pack.name)
                            .font(.headline)
                            .foregroundColor(.white)
                        if pack.isPremium && credits > 0 {
                            Text("\(credits) play\(credits == 1 ? "" : "s")")
                                .font(.caption2.weight(.bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.8))
                                .clipShape(Capsule())
                        }
                    }
                    if pack.isPremium {
                        Text("\(Theme.premiumQuestionsPerSession) random questions per session")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        Text("\(pack.questions.count) questions (Same demo questions every time)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text(pack.packDescription)
                        .font(.caption2)
                        .foregroundColor(.gray.opacity(0.7))
                }

                Spacer()

                if isLocked {
                    let product = pack.productID.flatMap { storeManager.product(for: $0) }
                    HStack(spacing: 4) {
                        Image(systemName: "lock.fill")
                        Text(product?.displayPrice ?? "$2.99")
                    }
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.purple)
                } else {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .purple : .gray)
                        .font(.title2)
                }
            }
            .padding(16)
            .background(isLocked ? Color.white.opacity(0.03) : (isSelected ? Color.purple.opacity(0.15) : Color.white.opacity(0.05)))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 2)
            )
        }
    }

    private func startGame() {
        guard let selectedPack = allPacks.first(where: { $0.id == selectedPackID }) else { return }

        // Build questions first: 10 random for premium, all for free
        let questions: [Question]
        if selectedPack.isPremium {
            questions = Array(selectedPack.questions.shuffled().prefix(Theme.premiumQuestionsPerSession))
        } else {
            questions = selectedPack.questions
        }

        guard !questions.isEmpty else { return }

        // Consume credit for premium pack only after validating questions exist
        if selectedPack.isPremium {
            guard let productID = selectedPack.productID, storeManager.consumeCredit(for: productID) else {
                showCreditsAlert = true
                return
            }
        }

        gameSession = GameSession(players: players, questions: questions)
    }
}
