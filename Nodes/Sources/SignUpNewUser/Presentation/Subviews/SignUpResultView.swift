import SwiftUI
import UILibrary

struct SignUpResultView: View {
    
    private let title: String
    private let image: Image
    private let buttonTitle: String
    private let action: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    init(
        title: String,
        image: Image,
        buttonTitle: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.image = image
        self.buttonTitle = buttonTitle
        self.action = action
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center, spacing: 24) {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                Text(title)
                    .font(.heading1)
                    .foregroundStyle(Color.primaryLabel)
                    .multilineTextAlignment(.center)
                
                Button(buttonTitle, action: action)
                    .buttonStyle(.primary)
            }
            .primaryBackground()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: dismiss.callAsFunction) {
                        Image.closeIcon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .frame(minWidth: 44, minHeight: 44)
                }
            }
        }
    }
}
