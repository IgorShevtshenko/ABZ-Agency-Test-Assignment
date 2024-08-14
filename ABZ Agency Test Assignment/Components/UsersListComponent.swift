import SwiftUI
import GetUsers
import GetUsersImpl
import UsersRepository
import UsersRepositoryImpl
import NetworkClientImpl
import PhoneNumberService
import PhoneNumberServiceImpl
import UsersList

struct UsersListComponent {
    
    private let usersRepository: UsersRepository
    private let phoneNumberService: PhoneNumberService
    
    init() {
        self.usersRepository = UsersRepositoryImpl(
            client: NetworkClientImpl(
                session: .shared,
            requestSerializer: JSONRequestSerializer(),
                responseSerializer: JSONResponseSerializer(),
                endpointConfiguration: EndpointConfigurationImpl()
            )
        )
        self.phoneNumberService = PhoneNumberServiceImpl()
    }
    
    func makeUsersList() -> some View {
        let viewModel = UsersListViewModel(
            getUsers: GetUsersImpl(usersRepository: usersRepository),
            phoneNumberService: phoneNumberService
        )
        return UsersList(viewModel: viewModel)
    }
}
