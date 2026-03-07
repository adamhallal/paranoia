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

                Text("REVEALED!")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(.green)

                Text("\(playerName) was asked:")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(question)
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            } else {
                Image(systemName: "eye.slash.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.red)

                Text("SECRET!")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(.red)

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
                    .font(.title3.weight(.bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
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
