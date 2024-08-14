import SwiftUI
import GetUsers
import GetUsersImpl
import UsersRepository
import UsersRepositoryImpl
import NetworkClientImpl
import PhoneNumberService
import PhoneNumberServiceImpl
import UsersList

struct UsersListComponent: Component {
    
    let parent: RootComponent
    
    func makeUsersList() -> some View {
        let viewModel = UsersListViewModel(
            getUsers: GetUsersImpl(usersRepository: parent.usersRepository),
            phoneNumberService: parent.phoneNumberService
        )
        return UsersList(viewModel: viewModel)
    }
}
