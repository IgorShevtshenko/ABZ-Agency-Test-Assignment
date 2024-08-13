import SwiftUI

public extension Binding where Value: Equatable {

    func removeDuplicates() -> Self {
        Binding(
            get: { wrappedValue },
            set: { newValue, transaction in
                guard newValue != wrappedValue else { return }
                self.transaction(transaction).wrappedValue = newValue
            }
        )
    }
}
