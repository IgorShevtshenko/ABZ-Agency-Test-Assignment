import SwiftUI
import Domain
import UILibrary
import Architecture

public struct UsersList: View {
    
    @ObservedObject private var viewModel: ViewModel<UsersListState, UsersListAction>
    
    public init(viewModel: ViewModel<UsersListState, UsersListAction>) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            switch viewModel.state.state {
            case .success(let users):
                List(users) { user in
                    let isLast = user == users.last
                    VStack(spacing: 0) {
                        UserCell(user: user, isLast: isLast)
                        
                        if isLast, viewModel.state.isMoreAvailable {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.progressViewColor)
                                .controlSize(.large)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .task {
                                    viewModel.send(.loadMore)
                                }
                        }
                    }
                        .listRowBackground(Color.backgroundColor)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listStyle(.plain)
                .listRowSpacing(24)
                .safeAreaPadding(.vertical, 24)
                .clipped()
                .animation(.default, value: users)
            case .empty:
                EmptyUsersList()
            case .noInternetConnection:
                NoInternetConnectionErrorView {
                    viewModel.send(.fetchUsers)
                }
            }
        }
        .primaryBackground()
        .animation(.default, value: viewModel.state.state)
        .transition(.opacity)
    }
}
