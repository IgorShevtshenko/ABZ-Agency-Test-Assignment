import SwiftUI

public struct RadioButton: View {
    
    private let title: String
    private let isSelected: Bool

    private let action: () -> Void
    
    public init(title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 25) {
                Group {
                    if isSelected {
                        Image.radioButtonSelected
                            .resizable()
                    } else {
                        Image.radioButton
                            .resizable()
                    }
                }
                .scaledToFit()
                .frame(width: 14, height: 14)
                .padding(17)
                
                Text(title)
                    .font(.body1)
                    .foregroundStyle(Color.primaryLabel)
            }
        }
    }
}
