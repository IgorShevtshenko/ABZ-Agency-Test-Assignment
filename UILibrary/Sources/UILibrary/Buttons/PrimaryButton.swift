import SwiftUI

public extension ButtonStyle where Self == PrimaryButtonStyle {

    static var primary: Self {
        PrimaryButtonStyle()
    }
}

public struct PrimaryButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.button1)
            .foregroundStyle(isEnabled ? Color.primaryLabel : .disabledLabel)
            .padding(.vertical, 12)
            .padding(.horizontal, 39)
            .background {
                buttonColor(for: configuration)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
    }
    
    func buttonColor(for configuration: Configuration) -> Color {
        guard isEnabled else {
            return .disabledColor
        }
        return configuration.isPressed ? .tappedPrimaryButtonColor : .primaryColor
    }
}
