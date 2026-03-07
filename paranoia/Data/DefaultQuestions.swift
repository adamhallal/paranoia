import Foundation

struct DefaultQuestions {
    static func allPacks() -> [QuestionPack] {
        [partyPack(), spicyPack(), chillPack()]
    }

    static func partyPack() -> QuestionPack {
        QuestionPack(name: "Party", questions: [
            Question(text: "Who is most likely to embarrass themselves on a dance floor?"),
            Question(text: "Who would survive the longest in a horror movie?"),
            Question(text: "Who is the worst at keeping secrets?"),
            Question(text: "Who would be the first to eat something weird on a dare?"),
            Question(text: "Who talks the most trash but can't back it up?"),
            Question(text: "Who would accidentally go viral on social media?"),
            Question(text: "Who is most likely to show up to the wrong party?"),
            Question(text: "Who gives the worst directions?"),
            Question(text: "Who would win a karaoke competition?"),
            Question(text: "Who is the biggest lightweight?"),
            Question(text: "Who would be the funniest stand-up comedian?"),
            Question(text: "Who takes the longest to get ready?"),
            Question(text: "Who is most likely to forget someone's name mid-conversation?"),
            Question(text: "Who has the most embarrassing photo on their phone?"),
            Question(text: "Who would be the worst at a lie detector test?"),
            Question(text: "Who is most likely to laugh at the worst possible moment?"),
            Question(text: "Who would cry first watching a sad movie?"),
            Question(text: "Who has the most questionable search history?"),
            Question(text: "Who would be most likely to befriend a celebrity?"),
            Question(text: "Who is secretly the most competitive?"),
        ])
    }

    static func spicyPack() -> QuestionPack {
        QuestionPack(name: "Spicy", questions: [
            Question(text: "Who has the biggest crush on someone in this room?"),
            Question(text: "Who is the biggest flirt without realizing it?"),
            Question(text: "Who has the most interesting dating history?"),
            Question(text: "Who would ghost someone and feel zero guilt?"),
            Question(text: "Who has definitely stalked an ex on social media?"),
            Question(text: "Who gives the worst relationship advice?"),
            Question(text: "Who is most likely to date someone their friends don't approve of?"),
            Question(text: "Who has the most embarrassing drunk text?"),
            Question(text: "Who would be the most dramatic in a breakup?"),
            Question(text: "Who thinks they're smoother than they actually are?"),
            Question(text: "Who would accidentally like an old photo while stalking someone?"),
            Question(text: "Who has the most unresolved situationship?"),
            Question(text: "Who would write the most unhinged love letter?"),
            Question(text: "Who is most likely to fall for a pickup line?"),
            Question(text: "Who would get caught lying about their body count?"),
            Question(text: "Who secretly judges everyone's relationships?"),
            Question(text: "Who is the biggest hopeless romantic here?"),
            Question(text: "Who has sent a risky text they immediately regretted?"),
            Question(text: "Who would be the most chaotic on a dating show?"),
            Question(text: "Who has the most 'it's complicated' situation right now?"),
        ])
    }

    static func chillPack() -> QuestionPack {
        QuestionPack(name: "Chill", questions: [
            Question(text: "Who gives the best hugs?"),
            Question(text: "Who would you call first in an emergency?"),
            Question(text: "Who is the best listener in this group?"),
            Question(text: "Who would make the best travel buddy?"),
            Question(text: "Who has the most contagious laugh?"),
            Question(text: "Who would you trust to plan your birthday party?"),
            Question(text: "Who is most likely to become famous for something wholesome?"),
            Question(text: "Who is the best cook in this group?"),
            Question(text: "Who gives the best life advice?"),
            Question(text: "Who would you want on your team in a trivia game?"),
            Question(text: "Who has the best music taste?"),
            Question(text: "Who would you want as a roommate?"),
            Question(text: "Who is the most likely to randomly check in on you?"),
            Question(text: "Who has the most calming presence?"),
            Question(text: "Who would you trust with your deepest secret?"),
            Question(text: "Who is most likely to brighten your day with a text?"),
            Question(text: "Who has the best sense of humor?"),
            Question(text: "Who would survive the longest on a deserted island?"),
            Question(text: "Who is the most underrated person in this group?"),
            Question(text: "Who would you want to be stuck in an elevator with?"),
        ])
    }
}
