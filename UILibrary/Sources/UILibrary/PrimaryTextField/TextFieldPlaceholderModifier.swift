import SwiftUI

struct TextFieldPlaceholderModifier: ViewModifier {
    
    private let placeholder: String
    private let foregroundColor: Color
    private let isActivePlaceholder: Bool
    
    public init(
        placeholder: String,
        foregroundColor: Color,
        isActivePlaceholder: Bool
    ) {
        self.placeholder = placeholder
        self.foregroundColor = foregroundColor
        self.isActivePlaceholder = isActivePlaceholder
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                VStack(alignment: .leading, spacing: 0) {
                    Text(placeholder)
                        .font(isActivePlaceholder ? .body4 : .body1)
                        .foregroundColor(foregroundColor)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, isActivePlaceholder ? 8 : 0)
                    
                    if isActivePlaceholder {
                        Spacer()
                    }
                }
                .allowsHitTesting(false)
            }
    }
}
