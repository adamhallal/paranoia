import SwiftUI

enum Theme {
    static let premiumQuestionsPerSession = 10
    static let maxNameLength = 16

    static let primaryGradient = LinearGradient(
        colors: [.purple, .pink],
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct PrimaryButtonStyle: ViewModifier {
    var isEnabled: Bool = true

    func body(content: Content) -> some View {
        content
            .font(.title3.weight(.bold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                isEnabled
                    ? AnyShapeStyle(Theme.primaryGradient)
                    : AnyShapeStyle(Color.gray.opacity(0.3))
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension View {
    func primaryButtonStyle(isEnabled: Bool = true) -> some View {
        modifier(PrimaryButtonStyle(isEnabled: isEnabled))
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundColor(.gray)
            Spacer()
        }
    }
}
