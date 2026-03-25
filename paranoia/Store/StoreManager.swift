import Foundation
import StoreKit

enum StoreProducts {
    static let spicyPack = "com.paranoia.pack.spicy"
    static let partyPack = "com.paranoia.pack.party"
    static let allProductIDs: Set<String> = [spicyPack, partyPack]

    static func productID(for packName: String) -> String? {
        switch packName.lowercased() {
        case "spicy": return spicyPack
        case "party": return partyPack
        default: return nil
        }
    }
}

@MainActor
@Observable
class StoreManager {
    private(set) var products: [Product] = []
    private(set) var purchaseInProgress = false
    private(set) var creditStore: [String: Int] = [:]
    private var transactionListener: Task<Void, Never>?

    init() {
        for id in StoreProducts.allProductIDs {
            creditStore[id] = UserDefaults.standard.integer(forKey: Self.creditKey(for: id))
        }
        transactionListener = listenForTransactions()
        Task { await loadProducts() }
    }

    deinit {
        transactionListener?.cancel()
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: StoreProducts.allProductIDs)
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func product(for id: String) -> Product? {
        products.first { $0.id == id }
    }

    func purchase(_ product: Product) async throws -> Bool {
        purchaseInProgress = true
        defer { purchaseInProgress = false }

        let result: Product.PurchaseResult
        do {
            result = try await product.purchase()
        } catch Product.PurchaseError.productUnavailable {
            throw StoreError.productUnavailable
        } catch {
            throw StoreError.purchaseFailed(error)
        }

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await handleTransaction(transaction)
            await transaction.finish()
            return true
        case .userCancelled:
            return false
        case .pending:
            return false
        @unknown default:
            return false
        }
    }

    // MARK: - Credits

    func credits(for productID: String) -> Int {
        creditStore[productID] ?? 0
    }

    @discardableResult
    func consumeCredit(for productID: String) -> Bool {
        let current = credits(for: productID)
        guard current > 0 else { return false }
        let newValue = current - 1
        creditStore[productID] = newValue
        UserDefaults.standard.set(newValue, forKey: Self.creditKey(for: productID))
        return true
    }

    private func addCredits(for productID: String, count: Int = 1) {
        let current = credits(for: productID)
        let newValue = current + count
        creditStore[productID] = newValue
        UserDefaults.standard.set(newValue, forKey: Self.creditKey(for: productID))
    }

    private static func creditKey(for productID: String) -> String {
        "credits_\(productID)"
    }

    // MARK: - Private

    private func listenForTransactions() -> Task<Void, Never> {
        Task {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await self.handleTransaction(transaction)
                    await transaction.finish()
                }
            }
        }
    }

    private func handleTransaction(_ transaction: Transaction) async {
        if StoreProducts.allProductIDs.contains(transaction.productID) {
            addCredits(for: transaction.productID)
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
}

enum StoreError: Error, LocalizedError {
    case verificationFailed
    case productUnavailable
    case purchaseFailed(Error)

    var errorDescription: String? {
        switch self {
        case .verificationFailed:
            return "Transaction verification failed."
        case .productUnavailable:
            return "This product is currently unavailable."
        case .purchaseFailed:
            return "Purchase failed. Please try again."
        }
    }
}
