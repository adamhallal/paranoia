import Foundation
import SwiftData

@Model
class Question {
    var id: UUID
    var text: String

    init(text: String) {
        self.id = UUID()
        self.text = text
    }
}
