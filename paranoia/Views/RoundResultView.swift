import SwiftUI

struct RoundResultView: View {
    let question: String
    let playerName: String
    let wasRevealed: Bool
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            if wasRevealed {
                Image(systemName: "eye.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
                    .accessibilityHidden(true)

                Text("REVEALED!")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(.green)
                    .accessibilityLabel("Question revealed")

                Text("\(playerName) was asked:")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(question)
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .accessibilityLabel("Question: \(question)")
            } else {
                Image(systemName: "eye.slash.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.red)
                    .accessibilityHidden(true)

                Text("SECRET!")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(.red)
                    .accessibilityLabel("Question kept secret")

                Text("The question stays a mystery...")
                    .font(.title3)
                    .foregroundColor(.gray)

                Text("Stay paranoid.")
                    .font(.headline)
                    .foregroundColor(.pink)
            }

            Spacer()

            Button(action: onContinue) {
                Text("Next Round")
                    .primaryButtonStyle()
            }
            .accessibilityLabel("Next round")
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        RoundResultView(
            question: "Who is most likely to cry at a movie?",
            playerName: "Alex",
            wasRevealed: true
        ) {}
    }
}
