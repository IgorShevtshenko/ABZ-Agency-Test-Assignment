import Architecture
import CoreNode
import SwiftUI
import UsersRepository
import UsersRepositoryImpl
import PhoneNumberService
import PhoneNumberServiceImpl
import NetworkClientImpl

struct RootComponent: Component {
    
    let usersRepository: UsersRepository
    let phoneNumberService: PhoneNumberService
    
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
    
    func makeRoot() -> some View {
        let viewModel = CoreViewModel()
        return CoreView(
            signUp: SignUpNewUserComponent(parent: self).makeSignUpNewUser,
            usersList: UsersListComponent(parent: self).makeUsersList,
            viewModel: viewModel
        )
    }
}
