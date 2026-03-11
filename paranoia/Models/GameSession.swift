import Foundation

@Observable
class GameSession: Identifiable {
    let id = UUID()
    var players: [Player]
    var rounds: [Round] = []
    var currentPlayerIndex: Int = 0
    var remainingQuestions: [Question]

    var currentPlayer: Player {
        players[min(currentPlayerIndex, players.count - 1)]
    }

    var isFinished: Bool {
        remainingQuestions.isEmpty
    }

    init(players: [Player], questions: [Question]) {
        self.players = players
        self.remainingQuestions = questions.shuffled()
    }

    func nextQuestion() -> Question? {
        guard !remainingQuestions.isEmpty else { return nil }
        return remainingQuestions.removeFirst()
    }

    func advancePlayer() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
    }

    func addRound(_ round: Round) {
        rounds.append(round)
        advancePlayer()
    }
}
