import SwiftUI
import StoreKit

struct PackPurchaseView: View {
    let pack: QuestionPack
    @Environment(StoreManager.self) private var storeManager
    @Environment(\.dismiss) private var dismiss

    @State private var isPurchasing = false
    @State private var errorMessage: String?
    @State private var showSuccess = false

    private var product: Product? {
        guard let productID = pack.productID else { return nil }
        return storeManager.product(for: productID)
    }

    private var currentCredits: Int {
        guard let productID = pack.productID else { return 0 }
        return storeManager.credits(for: productID)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: currentCredits > 0 ? "checkmark.seal.fill" : "lock.open.fill")
                    .font(.system(size: 50))
                    .foregroundColor(currentCredits > 0 ? .green : .purple)

                Text(pack.name)
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(.white)

                Text("10 random questions per session")
                    .font(.headline)
                    .foregroundColor(.gray)

                Text("Different questions each time you play!")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                if currentCredits > 0 {
                    Text("You have \(currentCredits) session\(currentCredits == 1 ? "" : "s") remaining")
                        .font(.headline)
                        .foregroundColor(.green)
                }

                Spacer()

                if showSuccess {
                    Label("Session added!", systemImage: "checkmark.circle.fill")
                        .font(.subheadline.weight(.bold))
                        .foregroundColor(.green)
                }

                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 32)
                }

                if let product = product {
                    Button {
                        Task { await purchasePack(product) }
                    } label: {
                        HStack {
                            if isPurchasing {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text(currentCredits > 0 ? "Buy Again \(product.displayPrice)" : "Buy \(product.displayPrice)")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                        }
                        .font(.title3.weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .disabled(isPurchasing)
                    .padding(.horizontal, 32)
                } else {
                    Text("Product not available")
                        .foregroundColor(.red)
                }

                Button("Close") {
                    dismiss()
                }
                .foregroundColor(.gray)
                .padding(.bottom, 40)
            }
        }
    }

    private func purchasePack(_ product: Product) async {
        isPurchasing = true
        errorMessage = nil
        showSuccess = false

        do {
            let success = try await storeManager.purchase(product)
            if success {
                showSuccess = true
            }
        } catch {
            errorMessage = "Purchase failed. Please try again."
        }

        isPurchasing = false
    }
}
