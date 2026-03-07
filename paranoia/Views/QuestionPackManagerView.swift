import SwiftUI
import SwiftData

struct QuestionPackManagerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var packs: [QuestionPack]
    @State private var showCreatePack = false
    @State private var editingPack: QuestionPack?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                if packs.isEmpty {
                    Spacer()
                    Text("No question packs yet")
                        .foregroundColor(.gray)
                    Text("Default packs are added on first launch")
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.7))
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(packs) { pack in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(pack.name)
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            if pack.isCustom {
                                                Text("CUSTOM")
                                                    .font(.caption2.weight(.bold))
                                                    .foregroundColor(.purple)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(Color.purple.opacity(0.2))
                                                    .clipShape(Capsule())
                                            }
                                        }
                                        Text("\(pack.questions.count) questions")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    if pack.isCustom {
                                        Button {
                                            editingPack = pack
                                        } label: {
                                            Image(systemName: "pencil.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.purple)
                                        }

                                        Button {
                                            modelContext.delete(pack)
                                        } label: {
                                            Image(systemName: "trash.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.red.opacity(0.7))
                                        }
                                    }
                                }
                                .padding(16)
                                .background(Color.white.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    }
                }
            }
        }
        .navigationTitle("Question Packs")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showCreatePack = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.purple)
                }
            }
        }
        .sheet(isPresented: $showCreatePack) {
            EditPackView(pack: nil)
        }
        .sheet(item: $editingPack) { pack in
            EditPackView(pack: pack)
        }
        .onAppear {
            seedDefaultPacksIfNeeded()
        }
    }

    private func seedDefaultPacksIfNeeded() {
        guard packs.isEmpty else { return }
        for pack in DefaultQuestions.allPacks() {
            modelContext.insert(pack)
        }
    }
}

struct EditPackView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let pack: QuestionPack?

    @State private var name: String = ""
    @State private var questionTexts: [String] = [""]

    var isEditing: Bool { pack != nil }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        TextField("Pack Name", text: $name)
                            .textFieldStyle(.plain)
                            .padding(14)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)

                        Text("Questions")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)

                        ForEach(questionTexts.indices, id: \.self) { index in
                            HStack {
                                TextField("Question \(index + 1)", text: $questionTexts[index])
                                    .textFieldStyle(.plain)
                                    .padding(12)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .foregroundColor(.white)

                                if questionTexts.count > 1 {
                                    Button {
                                        questionTexts.remove(at: index)
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red.opacity(0.7))
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }

                        Button {
                            questionTexts.append("")
                        } label: {
                            Label("Add Question", systemImage: "plus.circle")
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Pack" : "New Pack")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.gray)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .foregroundColor(.purple)
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if let pack {
                    name = pack.name
                    questionTexts = pack.questions.map { $0.text }
                    if questionTexts.isEmpty { questionTexts = [""] }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func save() {
        let validQuestions = questionTexts
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .map { Question(text: $0) }

        if let pack {
            pack.name = name.trimmingCharacters(in: .whitespaces)
            pack.questions = validQuestions
        } else {
            let newPack = QuestionPack(
                name: name.trimmingCharacters(in: .whitespaces),
                questions: validQuestions,
                isCustom: true
            )
            modelContext.insert(newPack)
        }
        dismiss()
    }
}
