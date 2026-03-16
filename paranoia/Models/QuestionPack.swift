import Foundation
import SwiftData

@Model
class QuestionPack {
    var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade) var questions: [Question]
    var isPremium: Bool
    var productID: String?

    static let premiumOrder = ["Spicy", "Party", "Same Side"]

    init(name: String, questions: [Question] = [], isPremium: Bool = false, productID: String? = nil) {
        self.id = UUID()
        self.name = name
        self.questions = questions
        self.isPremium = isPremium
        self.productID = productID
    }
}
