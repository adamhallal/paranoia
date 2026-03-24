import Foundation
import SwiftData

@Model
class QuestionPack {
    var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade) var questions: [Question]
    var isPremium: Bool
    var productID: String?
    var version: Int = 1

    static let premiumOrder = ["Spicy", "Party", "Same Side"]

    init(name: String, questions: [Question] = [], isPremium: Bool = false, productID: String? = nil, version: Int = 1) {
        self.id = UUID()
        self.name = name
        self.questions = questions
        self.isPremium = isPremium
        self.productID = productID
        self.version = version
    }
}
