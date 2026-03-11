import SwiftUI

struct PlayerSetupView: View {
    @State private var players: [Player] = []
    @State private var newName = ""
    @State private var showPackSelection = false
    @FocusState private var isInputFocused: Bool

    private var canStart: Bool {
        players.count >= 3
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Who's Playing?")
                    .font(.title.weight(.bold))
                    .foregroundColor(.white)

                Text("Add at least 3 players")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                // Player input
                HStack {
                    TextField("Enter name", text: $newName)
                        .textFieldStyle(.plain)
                        .padding(14)
                        .background(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .foregroundColor(.white)
                        .focused($isInputFocused)
                        .onSubmit { addPlayer() }
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.words)
                        .onChange(of: newName) {
                            let filtered = String(newName.unicodeScalars.filter { CharacterSet.alphanumerics.contains($0) })
                            if filtered.count > 16 {
                                newName = String(filtered.prefix(16))
                            } else if filtered != newName {
                                newName = filtered
                            }
                        }

                    Button(action: addPlayer) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.purple)
                    }
                    .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.horizontal, 24)

                // Player list
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(Array(players.enumerated()), id: \.element.id) { index, player in
                            HStack {
                                Text("\(index + 1).")
                                    .foregroundColor(.gray)
                                    .frame(width: 30)

                                Text(player.name)
                                    .foregroundColor(.white)

                                Spacer()

                                Button {
                                    players.removeAll { $0.id == player.id }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red.opacity(0.7))
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()

                Button {
                    showPackSelection = true
                } label: {
                    Text("Choose Questions")
                        .font(.title3.weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            canStart
                                ? AnyShapeStyle(LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing))
                                : AnyShapeStyle(Color.gray.opacity(0.3))
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(!canStart)
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
            }
            .padding(.top, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showPackSelection) {
            PackSelectionView(players: players)
        }
    }

    private func addPlayer() {
        let trimmed = newName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        guard !players.contains(where: { $0.name.lowercased() == trimmed.lowercased() }) else { return }
        players.append(Player(name: trimmed))
        newName = ""
        isInputFocused = true
    }
}

#Preview {
    NavigationStack {
        PlayerSetupView()
    }
}
