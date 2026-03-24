import Foundation

struct DemoQuestions {
    static func starterPack() -> QuestionPack {
        QuestionPack(name: "Starter", questions: [
            Question(text: "Who is most likely to laugh at the worst possible moment?"),
            Question(text: "Who would survive the longest in a horror movie?"),
            Question(text: "Who gives the best hugs?"),
            Question(text: "Who is the biggest lightweight?"),
            Question(text: "Who has the most contagious laugh?"),
            Question(text: "Who would be the worst at keeping a surprise party secret?"),
            Question(text: "Who is most likely to trip over nothing?"),
            Question(text: "Who has the best dance moves?"),
            Question(text: "Who would be the first to cry during a sad movie?"),
            Question(text: "Who is the most likely to forget someone's name right after meeting them?"),
        ], version: 2)
    }
}
