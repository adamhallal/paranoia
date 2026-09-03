import SwiftUI
import SwiftData

struct QuestionPackManagerView: View {
    @Environment(StoreManager.self) private var storeManager
    @Query private var packs: [QuestionPack]
    @State private var purchasePack: QuestionPack?

    private var freePacks: [QuestionPack] { QuestionPack.freePacks(from: packs) }
    private var premiumPacks: [QuestionPack] { QuestionPack.premiumPacks(from: packs) }

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
                                SectionHeader(title: "FREE")
                                ForEach(freePacks) { pack in
                                    freePackRow(pack: pack)
                                }
                            }

                            if !premiumPacks.isEmpty {
                                SectionHeader(title: "PREMIUM")
                                    .padding(.top, 8)
                                ForEach(premiumPacks) { pack in
                                    premiumPackRow(pack: pack)
                                }
                            }

                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    }

                    Spacer()

                    VStack(spacing: 12) {
                        SectionHeader(title: "MORE COMING SOON")
                        suggestionCard()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
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
                Text(pack.packDescription)
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

    private static let suggestionsURL = URL(string: "mailto:support@jnoon.app?subject=Paranoia%20Question%20Suggestion")!

    private func suggestionCard() -> some View {
        Link(destination: Self.suggestionsURL) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                        Text("Suggest Questions")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    Text("Have an idea for a new question or pack? Let us know!")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: "arrow.up.right")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            .padding(16)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
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
                    Text("\(Theme.premiumQuestionsPerSession) questions per session")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(pack.packDescription)
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
