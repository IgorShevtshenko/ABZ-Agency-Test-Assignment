import SwiftUI
import UILibrary
import Domain

struct PositionPicker: View {
    
    private let positions: [Position]
    
    @Binding private var selectedPosition: Position?
    
    public init(positions: [Position], selectedPosition: Binding<Position?>) {
        self.positions = positions
        _selectedPosition = selectedPosition
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select your position")
                .font(.body2)
                .foregroundStyle(Color.primaryLabel)
            VStack(alignment: .leading, spacing: 0) {
                ForEach(positions) { position in
                    RadioButton(
                        title: position.name,
                        isSelected: position == selectedPosition
                    ) {
                            selectedPosition = position
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
