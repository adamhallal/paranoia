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
            let existingNames = Set(existingPacks.map { $0.name })

            if !existingNames.contains("Starter") {
                context.insert(DemoQuestions.starterPack())
            }
            for pack in DefaultQuestions.allPacks() where !existingNames.contains(pack.name) {
                context.insert(pack)
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
