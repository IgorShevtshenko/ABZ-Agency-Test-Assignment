import SwiftUI

public struct NoInternetConnectionErrorView: View {
    
    private let tryAgainAction: () -> Void
    
    public init(tryAgainAction: @escaping () -> Void) {
        self.tryAgainAction = tryAgainAction
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Image.noInternetConnection
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text("There is no internet connection")
                .font(.heading1)
                .foregroundStyle(Color.primaryLabel)
            
            Button("Try again", action: tryAgainAction)
                .buttonStyle(.primary)
        }
    }
}
