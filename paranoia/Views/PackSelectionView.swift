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

    private static let premiumOrder = ["Spicy", "Party", "Couple"]

    private var freePacks: [QuestionPack] {
        allPacks.filter { !$0.isPremium && !$0.questions.isEmpty }
    }

    private var premiumPacks: [QuestionPack] {
        allPacks.filter { $0.isPremium && !$0.questions.isEmpty }
            .sorted { Self.premiumOrder.firstIndex(of: $0.name) ?? 99 < Self.premiumOrder.firstIndex(of: $1.name) ?? 99 }
    }

    private static func packDescription(for name: String) -> String {
        switch name {
        case "Starter": return "Same 5 demo questions every time — upgrade to a premium pack for more"
        case "Spicy": return "Bold and daring questions to turn up the heat"
        case "Party": return "Fun and wild questions perfect for any group"
        case "Couple": return "Intimate questions for you and your partner"
        default: return ""
        }
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
                            sectionHeader("FREE")
                            ForEach(freePacks) { pack in
                                packRow(pack: pack, isFree: true)
                            }
                        }

                        if !premiumPacks.isEmpty {
                            sectionHeader("PREMIUM")
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

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundColor(.gray)
            Spacer()
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
                        Text("10 random questions per session")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        Text("\(pack.questions.count) questions")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text(Self.packDescription(for: pack.name))
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

        // Check credits for premium pack
        if selectedPack.isPremium {
            guard let productID = selectedPack.productID, storeManager.credits(for: productID) > 0 else {
                showCreditsAlert = true
                return
            }
            storeManager.consumeCredit(for: productID)
        }

        // Build questions: 10 random for premium, all for free/custom
        let questions: [Question]
        if selectedPack.isPremium {
            questions = Array(selectedPack.questions.shuffled().prefix(10))
        } else {
            questions = selectedPack.questions
        }

        gameSession = GameSession(players: players, questions: questions)
    }
}
