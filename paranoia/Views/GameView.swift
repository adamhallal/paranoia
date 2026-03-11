import SwiftUI

enum GamePhase {
    case passPhone
    case showQuestion
    case answered
    case coinFlip
    case result
}

struct GameView: View {
    @Bindable var session: GameSession
    @Environment(\.dismiss) private var dismiss

    @State private var phase: GamePhase = .passPhone
    @State private var currentQuestion: Question?
    @State private var wasRevealed = false
    @State private var showSummary = false
    @State private var showExitConfirmation = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                HStack {
                    Button {
                        showExitConfirmation = true
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.weight(.bold))
                            .foregroundColor(.gray)
                            .padding(10)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("Leave game")

                    Spacer()

                    Text("\(session.remainingQuestions.count) left")
                        .font(.caption.weight(.bold))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Capsule())
                        .accessibilityLabel("\(session.remainingQuestions.count) questions remaining")
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                Spacer()
            }

            switch phase {
            case .passPhone:
                passPhoneScreen
            case .showQuestion:
                questionScreen
            case .answered:
                answeredScreen
            case .coinFlip:
                CoinFlipView { isHeads in
                    wasRevealed = isHeads
                    withAnimation { phase = .result }
                }
            case .result:
                RoundResultView(
                    question: currentQuestion?.text ?? "",
                    playerName: session.currentPlayer.name,
                    wasRevealed: wasRevealed
                ) {
                    finishRound()
                }
            }
        }
        .fullScreenCover(isPresented: $showSummary) {
            GameSummaryView(rounds: session.rounds) {
                dismiss()
            }
        }
        .alert("Leave Game?", isPresented: $showExitConfirmation) {
            Button("Keep Playing", role: .cancel) { }
            Button("Leave", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Your progress will be lost and the pack will be used.")
        }
    }

    private var passPhoneScreen: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "iphone.and.arrow.forward")
                .font(.system(size: 60))
                .foregroundColor(.purple)

            Text("Pass the phone to")
                .font(.title3)
                .foregroundColor(.gray)

            Text(session.currentPlayer.name)
                .font(.system(size: 40, weight: .black, design: .rounded))
                .foregroundColor(.white)

            Text("Only they should see the screen!")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()

            Button {
                currentQuestion = session.nextQuestion()
                if currentQuestion != nil {
                    withAnimation { phase = .showQuestion }
                } else {
                    showSummary = true
                }
            } label: {
                Text("I'm \(session.currentPlayer.name)")
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

    private var questionScreen: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("Your question:")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text(currentQuestion?.text ?? "")
                .font(.title.weight(.bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Text("Say someone's name out loud!")
                .font(.headline)
                .foregroundColor(.purple)

            Spacer()

            Button {
                HapticManager.lightTap()
                withAnimation { phase = .answered }
            } label: {
                Text("I've Answered")
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

    private var answeredScreen: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("Everyone heard the answer...")
                .font(.title3)
                .foregroundColor(.gray)

            Text("Now let's see if the question gets revealed!")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            Button {
                withAnimation { phase = .coinFlip }
            } label: {
                Text("Flip the Coin")
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

    private func finishRound() {
        guard let question = currentQuestion else { return }
        let round = Round(
            askedPlayer: session.currentPlayer,
            question: question,
            wasRevealed: wasRevealed
        )
        session.addRound(round)

        if session.isFinished {
            showSummary = true
        } else {
            wasRevealed = false
            currentQuestion = nil
            withAnimation { phase = .passPhone }
        }
    }
}
