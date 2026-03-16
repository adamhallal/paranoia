import Foundation

struct DefaultQuestions {
    static func allPacks() -> [QuestionPack] {
        [partyPack(), spicyPack(), sameSidePack()]
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

    static func sameSidePack() -> QuestionPack {
        QuestionPack(name: "Same Side", questions: [
            Question(text: "Who talks the most behind people's backs?"),
            Question(text: "Who has the worst taste in the people they're attracted to?"),
            Question(text: "Who thinks they're the hottest in the group but isn't?"),
            Question(text: "Who would sell everyone out for clout?"),
            Question(text: "Who is the most delusional about their love life?"),
            Question(text: "Who would get exposed first if everyone's DMs got leaked?"),
            Question(text: "Who acts the most different around people they like?"),
            Question(text: "Who has the biggest ego in this room?"),
            Question(text: "Who is lowkey the most jealous of someone here?"),
            Question(text: "Who would be the first to break a pinky promise?"),
            Question(text: "Who is the fakest nice person here?"),
            Question(text: "Who thinks they give good advice but actually doesn't?"),
            Question(text: "Who has the most secrets they've never told the group?"),
            Question(text: "Who would throw someone under the bus to save themselves?"),
            Question(text: "Who is most likely to have a secret social media account?"),
            Question(text: "Who overestimates how funny they are?"),
            Question(text: "Who is the worst at apologizing?"),
            Question(text: "Who is the most dramatic over nothing?"),
            Question(text: "Who would be the first to crack under pressure?"),
            Question(text: "Who has the most embarrassing guilty pleasure they won't admit?"),
        ], isPremium: true, productID: StoreProducts.sameSidePack)
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

}
