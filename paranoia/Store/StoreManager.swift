import Foundation
import StoreKit

enum StoreProducts {
    static let spicyPack = "com.paranoia.pack.spicy"
    static let partyPack = "com.paranoia.pack.party"
    static let couplePack = "com.paranoia.pack.couple"
    static let allProductIDs: Set<String> = [spicyPack, partyPack, couplePack]
    static let packProductIDs: Set<String> = [spicyPack, partyPack, couplePack]

    static func productID(for packName: String) -> String? {
        switch packName.lowercased() {
        case "spicy": return spicyPack
        case "party": return partyPack
        case "couple": return couplePack
        default: return nil
        }
    }
}

@Observable
class StoreManager {
    private(set) var products: [Product] = []
    private(set) var purchaseInProgress = false
    private(set) var creditStore: [String: Int] = [:]
    private var transactionListener: Task<Void, Never>?

    init() {
        // Load credits from UserDefaults into observable dictionary
        for id in StoreProducts.packProductIDs {
            creditStore[id] = UserDefaults.standard.integer(forKey: "credits_\(id)")
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

        let result = try await product.purchase()

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

    /// Attempts to consume one credit. Returns true if successful, false if no credits available.
    @discardableResult
    func consumeCredit(for productID: String) -> Bool {
        let current = credits(for: productID)
        guard current > 0 else { return false }
        let newValue = current - 1
        creditStore[productID] = newValue
        UserDefaults.standard.set(newValue, forKey: "credits_\(productID)")
        return true
    }

    private func addCredits(for productID: String, count: Int = 1) {
        let current = credits(for: productID)
        let newValue = current + count
        creditStore[productID] = newValue
        UserDefaults.standard.set(newValue, forKey: "credits_\(productID)")
    }

    // MARK: - Restore (non-consumable only)

    func restorePurchases() async {
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result) {
                await handleTransaction(transaction)
            }
        }
    }

    // MARK: - Private

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                if let transaction = try? self?.checkVerified(result) {
                    await self?.handleTransaction(transaction)
                    await transaction.finish()
                }
            }
        }
    }

    private func handleTransaction(_ transaction: Transaction) async {
        if StoreProducts.packProductIDs.contains(transaction.productID) {
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

enum StoreError: Error {
    case verificationFailed
}
