import SwiftUI
import SwiftData

@main
struct ParanoiaApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: QuestionPack.self)
    }
}
