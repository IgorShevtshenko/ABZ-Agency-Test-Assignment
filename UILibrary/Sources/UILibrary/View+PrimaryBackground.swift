import SwiftUI


public extension View {
    
    func primaryBackground() -> some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()
            self
        }
    }
}
