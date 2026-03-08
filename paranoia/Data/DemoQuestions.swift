import Foundation

struct DemoQuestions {
    static func starterPack() -> QuestionPack {
        QuestionPack(name: "Starter", questions: [
            Question(text: "Who is most likely to laugh at the worst possible moment?"),
            Question(text: "Who would survive the longest in a horror movie?"),
            Question(text: "Who gives the best hugs?"),
            Question(text: "Who is the biggest lightweight?"),
            Question(text: "Who has the most contagious laugh?"),
        ])
    }
}
