import SwiftUI
import SwiftData

struct QuestionPackManagerView: View {
    @Environment(StoreManager.self) private var storeManager
    @Query private var packs: [QuestionPack]
    @State private var purchasePack: QuestionPack?

    private static let premiumOrder = ["Spicy", "Party", "Couple"]

    private var freePacks: [QuestionPack] {
        packs.filter { !$0.isPremium }
    }

    private var premiumPacks: [QuestionPack] {
        packs.filter { $0.isPremium }
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

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                if packs.isEmpty {
                    Spacer()
                    Text("No question packs yet")
                        .foregroundColor(.gray)
                    Text("Default packs are added on first launch")
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.7))
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            if !freePacks.isEmpty {
                                sectionHeader("FREE")
                                ForEach(freePacks) { pack in
                                    freePackRow(pack: pack)
                                }
                            }

                            if !premiumPacks.isEmpty {
                                sectionHeader("PREMIUM")
                                    .padding(.top, 8)
                                ForEach(premiumPacks) { pack in
                                    premiumPackRow(pack: pack)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    }
                }
            }
        }
        .navigationTitle("Question Packs")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $purchasePack) { pack in
            PackPurchaseView(pack: pack)
                .environment(storeManager)
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
    private func freePackRow(pack: QuestionPack) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(pack.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(pack.questions.count) questions")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(Self.packDescription(for: pack.name))
                    .font(.caption2)
                    .foregroundColor(.gray.opacity(0.7))
            }
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title2)
        }
        .padding(16)
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private func premiumPackRow(pack: QuestionPack) -> some View {
        let credits = pack.productID.map { storeManager.credits(for: $0) } ?? 0
        let product = pack.productID.flatMap { storeManager.product(for: $0) }

        Button {
            purchasePack = pack
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(pack.name)
                            .font(.headline)
                            .foregroundColor(.white)
                        if credits > 0 {
                            Text("\(credits) play\(credits == 1 ? "" : "s")")
                                .font(.caption2.weight(.bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green.opacity(0.8))
                                .clipShape(Capsule())
                        }
                    }
                    Text("10 questions per session")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(Self.packDescription(for: pack.name))
                        .font(.caption2)
                        .foregroundColor(.gray.opacity(0.7))
                }
                Spacer()
                VStack(spacing: 2) {
                    Text(credits > 0 ? "Buy More" : "Buy")
                        .font(.caption.weight(.bold))
                    Text(product?.displayPrice ?? "$2.99")
                        .font(.caption2)
                }
                .foregroundColor(.purple)
            }
            .padding(16)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
