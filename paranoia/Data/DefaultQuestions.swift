import Foundation

struct DefaultQuestions {
    static func allPacks() -> [QuestionPack] {
        [partyPack(), spicyPack(), couplePack()]
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
        ], isPremium: true, productID: StoreProducts.partyPack)
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
        ], isPremium: true, productID: StoreProducts.spicyPack)
    }

    static func couplePack() -> QuestionPack {
        QuestionPack(name: "Couple", questions: [
            Question(text: "Who is most likely to forget an anniversary?"),
            Question(text: "Who would plan the most romantic surprise date?"),
            Question(text: "Who is the bigger hopeless romantic in their relationship?"),
            Question(text: "Who is most likely to steal the covers at night?"),
            Question(text: "Who would win in a couple's argument every time?"),
            Question(text: "Who is most likely to say 'I love you' first?"),
            Question(text: "Who gives in first after a fight?"),
            Question(text: "Who is the clingier partner?"),
            Question(text: "Who would be the first to cry during a proposal?"),
            Question(text: "Who checks their partner's phone when they're not looking?"),
            Question(text: "Who would write the most embarrassing love poem?"),
            Question(text: "Who is most likely to fall asleep during movie night?"),
            Question(text: "Who is secretly the jealous type?"),
            Question(text: "Who remembers every little detail about their partner?"),
            Question(text: "Who would be the most dramatic if their partner didn't text back?"),
            Question(text: "Who is most likely to plan a surprise trip?"),
            Question(text: "Who gives the best compliments to their partner?"),
            Question(text: "Who would accidentally reveal a secret about their relationship?"),
            Question(text: "Who is more likely to post their partner on social media?"),
            Question(text: "Who would be the first to adopt a pet together?"),
        ], isPremium: true, productID: StoreProducts.couplePack)
    }
}
