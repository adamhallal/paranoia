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

    static let premiumOrder = ["Spicy", "Party"]

    init(name: String, questions: [Question] = [], isPremium: Bool = false, productID: String? = nil, version: Int = 1) {
        self.id = UUID()
        self.name = name
        self.questions = questions
        self.isPremium = isPremium
        self.productID = productID
        self.version = version
    }

    var packDescription: String {
        switch name {
        case "Starter": return "Upgrade to a premium pack for crazier questions"
        case "Spicy": return "Flirting, exes, and juicy confessions"
        case "Party": return "Embarrassing moments and hilarious callouts"
        default: return ""
        }
    }

    var detailedDescription: String {
        switch name {
        case "Spicy": return "Flirting, exes, dating drama, and juicy confessions — things are about to get real"
        case "Party": return "Embarrassing moments, wild dares, and hilarious callouts — perfect for any group hangout"
        default: return ""
        }
    }

    static func freePacks(from packs: [QuestionPack]) -> [QuestionPack] {
        packs.filter { !$0.isPremium && !$0.questions.isEmpty }
    }

    static func premiumPacks(from packs: [QuestionPack]) -> [QuestionPack] {
        packs.filter { $0.isPremium && !$0.questions.isEmpty }
            .sorted { (premiumOrder.firstIndex(of: $0.name) ?? .max) < (premiumOrder.firstIndex(of: $1.name) ?? .max) }
    }
}
