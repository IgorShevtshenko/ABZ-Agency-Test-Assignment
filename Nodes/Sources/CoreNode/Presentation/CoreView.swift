import Architecture
import SwiftUI
import UILibrary

public struct CoreView<UsersList: View, SignUp: View>: View {
    
    private let signUp: SignUp
    private let usersList: UsersList
    
    @ObservedObject private var viewModel: ViewModel<CoreState, CoreAction>
    
    public init(
        signUp: @escaping () -> SignUp,
        usersList: @escaping () -> UsersList,
        viewModel: ViewModel<CoreState, CoreAction>
    ) {
        self.signUp = signUp()
        self.usersList = usersList()
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            switch viewModel.state.activeTab {
            case .usersList:
                usersList
            case .signUp:
                signUp
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Button(action: { viewModel.send(.changeTab(tab)) }) {
                            HStack(alignment: .center, spacing: 8) {
                                tab.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 17)
                                Text(tab.title)
                                    .font(.button2)
                            }
                            .foregroundStyle(
                                tab == viewModel.state.activeTab
                                ? .secondaryColor
                                : Color.secondaryLabel
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
    }
}

private extension Tab {
    
    var image: Image {
        switch self {
        case .usersList:
                .usersTab
        case .signUp:
                .signUpTab
        }
    }
    
    var title: String {
        switch self {
        case .usersList:
            "Users"
        case .signUp:
            "Sign up"
        }
    }
}
