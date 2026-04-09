import Foundation

struct DemoQuestions {
    static func starterPack() -> QuestionPack {
        QuestionPack(name: "Starter", questions: [
            Question(text: "Who here is the worst liar?"),
            Question(text: "Who would be the first to get kicked out of a party?"),
            Question(text: "Who has the biggest ego in this room?"),
            Question(text: "Who is most likely to say something they regret?"),
            Question(text: "Who would you least want to share a secret with?"),
            Question(text: "Who is most likely to start drama for no reason?"),
            Question(text: "Who has the most contagious laugh?"),
            Question(text: "Who here thinks they're funnier than they actually are?"),
            Question(text: "Who here would you not trust with your phone for 5 minutes?"),
            Question(text: "Who is most likely to have a crush on someone in this room?"),
        ], version: 1)
    }
}
