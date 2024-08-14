import SwiftUI
import UILibrary

struct EmptyUsersList: View {
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Image.emptyUsersList
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Text("There are no users yet")
                .font(.heading1)
                .foregroundStyle(Color.primaryLabel)
        }
    }
}
