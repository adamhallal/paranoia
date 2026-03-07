import Foundation
import SwiftData

@Model
class QuestionPack {
    var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade) var questions: [Question]
    var isCustom: Bool

    init(name: String, questions: [Question] = [], isCustom: Bool = false) {
        self.id = UUID()
        self.name = name
        self.questions = questions
        self.isCustom = isCustom
    }
}
