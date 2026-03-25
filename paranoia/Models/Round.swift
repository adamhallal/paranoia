import Foundation

struct Round: Identifiable {
    let id = UUID()
    let askedPlayer: Player
    let question: Question
    let wasRevealed: Bool
}
