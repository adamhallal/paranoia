import SwiftUI

struct CoinFlipView: View {
    let onResult: (Bool) -> Void

    @State private var rotation: Double = 0
    @State private var isFlipping = false
    @State private var result: Bool? = nil

    var body: some View {
        VStack(spacing: 32) {
            Text("Flip the Coin")
                .font(.title2.weight(.bold))
                .foregroundColor(.white)

            Text("Heads = question revealed\nTails = stays a secret...")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 150, height: 150)
                    .shadow(color: .purple.opacity(0.5), radius: 20)

                if let result {
                    Text(result ? "H" : "T")
                        .font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                } else {
                    Text("?")
                        .font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .rotation3DEffect(.degrees(rotation), axis: (x: 1, y: 0, z: 0))

            if !isFlipping && result == nil {
                Button {
                    flipCoin()
                } label: {
                    Text("Tap to Flip")
                        .font(.title3.weight(.bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(Color.purple)
                        .clipShape(Capsule())
                }
            }

            if let result {
                Text(result ? "HEADS! Question revealed!" : "TAILS! It stays secret...")
                    .font(.title3.weight(.bold))
                    .foregroundColor(result ? .green : .red)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }

    private func flipCoin() {
        isFlipping = true
        let isHeads = Bool.random()

        withAnimation(.easeIn(duration: 0.8)) {
            rotation = 1080 + (isHeads ? 0 : 180)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            HapticManager.coinFlipImpact()
            withAnimation(.spring(response: 0.3)) {
                result = isHeads
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onResult(isHeads)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CoinFlipView { result in
            print("Result: \(result)")
        }
    }
}
