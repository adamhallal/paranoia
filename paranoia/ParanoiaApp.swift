import SwiftUI
import SwiftData

@main
struct ParanoiaApp: App {
    @State private var storeManager = StoreManager()
    let modelContainer: ModelContainer

    init() {
        do {
            let container = try ModelContainer(for: QuestionPack.self, Question.self)
            let context = container.mainContext
            let descriptor = FetchDescriptor<QuestionPack>()
            let existingPacks = (try? context.fetch(descriptor)) ?? []

            let freshPacks = [DemoQuestions.starterPack()] + DefaultQuestions.allPacks()
            for freshPack in freshPacks {
                if let existing = existingPacks.first(where: { $0.name == freshPack.name }) {
                    if existing.version < freshPack.version {
                        for question in existing.questions {
                            context.delete(question)
                        }
                        existing.questions = freshPack.questions
                        existing.version = freshPack.version
                    }
                } else {
                    context.insert(freshPack)
                }
            }

            do {
                try context.save()
            } catch {
                print("Failed to save question packs: \(error)")
            }
            self.modelContainer = container
        } catch {
            fatalError("Failed to initialize data store: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(storeManager)
        }
        .modelContainer(modelContainer)
    }
}
