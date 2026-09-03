import SwiftUI

struct HomeView: View {
    @Environment(StoreManager.self) private var storeManager
    @State private var showPlayerSetup = false
    @State private var showPackManager = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 40) {
                    Spacer()

                    VStack(spacing: 8) {
                        Text("PARANOIA")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundStyle(Theme.primaryGradient)

                        Text("What did they say about you?")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    VStack(spacing: 16) {
                        Button {
                            showPlayerSetup = true
                        } label: {
                            Text("Start Game")
                                .primaryButtonStyle()
                        }

                        Button {
                            showPackManager = true
                        } label: {
                            Text("Question Packs")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.purple)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.purple.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    .padding(.horizontal, 32)

                    Link("Privacy Policy", destination: URL(string: "https://adamhallal.github.io/paranoia/privacy")!)
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.6))
                        .padding(.bottom, 24)
                }
            }
            .navigationDestination(isPresented: $showPlayerSetup) {
                PlayerSetupView()
            }
            .navigationDestination(isPresented: $showPackManager) {
                QuestionPackManagerView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    HomeView()
}
