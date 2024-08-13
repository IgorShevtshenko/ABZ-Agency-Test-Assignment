import SwiftUI

public extension ButtonStyle where Self == SecondaryButton {

    static var secondary: Self {
        SecondaryButton()
    }
}

public struct SecondaryButton: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.button2)
            .foregroundStyle(isEnabled ? Color.secondaryDark : .disabledLabel)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background {
                buttonColor(for: configuration)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
    }
    
    func buttonColor(for configuration: Configuration) -> Color {
        configuration.isPressed ? Color.secondaryButtonBackground : .clear
    }
}
