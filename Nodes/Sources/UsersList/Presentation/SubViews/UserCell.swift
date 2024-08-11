import SwiftUI
import UILibrary
import Domain

struct UserCell: View {
    
    private let user: User
    private let isLast: Bool
    
    init(user: User, isLast: Bool) {
        self.user = user
        self.isLast = isLast
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: user.photoUrl) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .mask(Circle())
                } else {
                    Image.userImagePlaceholder
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                header
                personalInformation
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 24)
            .overlay(alignment: .bottom) {
                if !isLast {
                    VStack(spacing: 0) {
                        Divider()
                    }
                }
            }
        }
        .safeAreaPadding(.horizontal, 16)
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(user.name)
                .font(.body2)
                .foregroundStyle(Color.primaryLabel)
            Text(user.positionTitle)
                .font(.body3)
                .foregroundStyle(Color.secondaryLabel)
        }
    }
    
    private var personalInformation: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(user.email)
            Text(user.phone)
        }
        .font(.body3)
        .foregroundStyle(Color.primaryLabel)
    }
}
