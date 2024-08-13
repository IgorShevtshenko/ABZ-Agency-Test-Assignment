import SwiftUI

public extension View {
    
    func primaryNavBar(title: String) -> some View {
        modifier(PrimaryNavbarModifier(title: title))
    }
}
private struct PrimaryNavbarModifier: ViewModifier {
    
    private let title: String
    
    init(title: String) {
        self.title = title
    }
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.heading1)
                .foregroundStyle(Color.primaryLabel)
                .containerRelativeFrame(.horizontal)
                .padding(.vertical, 16)
                .background(Color.primaryColor)
                .clipped()
            content
        }
    }
}
