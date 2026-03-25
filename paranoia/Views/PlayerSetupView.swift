import SwiftUI

struct PlayerSetupView: View {
    @State private var players: [Player] = []
    @State private var newName = ""
    @State private var showPackSelection = false
    @FocusState private var isInputFocused: Bool

    private let minPlayers = 3
    private let maxPlayers = 10

    private var canStart: Bool {
        players.count >= minPlayers
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Who's Playing?")
                    .font(.title.weight(.bold))
                    .foregroundColor(.white)

                Text(players.count < minPlayers ? "Add at least \(minPlayers) players" : players.count >= maxPlayers ? "\(maxPlayers) players max" : "\(players.count) players")
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
                            // Allow alphanumerics and spaces
                            var filtered = String(newName.unicodeScalars.filter {
                                CharacterSet.alphanumerics.contains($0) || $0 == " "
                            })
                            // No leading spaces
                            while filtered.hasPrefix(" ") {
                                filtered.removeFirst()
                            }
                            // No consecutive spaces
                            while filtered.contains("  ") {
                                filtered = filtered.replacingOccurrences(of: "  ", with: " ")
                            }
                            // Enforce max length
                            if filtered.count > Theme.maxNameLength {
                                filtered = String(filtered.prefix(Theme.maxNameLength))
                            }
                            if filtered != newName {
                                newName = filtered
                            }
                        }

                    Button(action: addPlayer) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.purple)
                    }
                    .accessibilityLabel("Add player")
                    .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty || players.count >= maxPlayers)
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
                                .accessibilityLabel("Remove \(player.name)")
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
                        .primaryButtonStyle(isEnabled: canStart)
                }
                .disabled(!canStart)
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
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
        guard players.count < maxPlayers else { return }
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
