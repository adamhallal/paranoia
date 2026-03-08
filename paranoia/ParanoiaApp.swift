import SwiftUI
import SwiftData

@main
struct ParanoiaApp: App {
    @State private var storeManager = StoreManager()
    let modelContainer: ModelContainer

    init() {
        let container = try! ModelContainer(for: QuestionPack.self, Question.self)
        let context = container.mainContext
        let descriptor = FetchDescriptor<QuestionPack>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        if count == 0 {
            context.insert(DemoQuestions.starterPack())
            for pack in DefaultQuestions.allPacks() {
                context.insert(pack)
            }
            try? context.save()
        }
        self.modelContainer = container
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(storeManager)
        }
        .modelContainer(modelContainer)
    }
}
