import UIKit

struct HapticManager {
    private static let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private static let lightGenerator = UIImpactFeedbackGenerator(style: .light)

    static func coinFlipImpact() {
        heavyGenerator.impactOccurred()
    }

    static func lightTap() {
        lightGenerator.impactOccurred()
    }
}
