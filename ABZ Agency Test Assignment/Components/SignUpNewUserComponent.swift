import Architecture
import SwiftUI
import SignUpNewUser
import NetworkClientImpl
import NetworkClient
import SignUpImpl
import PositionsRepository
import PositionsRepositoryImpl
import SignUpFormValidatorImpl
import PhoneNumberServiceImpl
import AuthenticationTokenRepository
import AuthenticationTokenRepositoryImpl

struct SignUpNewUserComponent: Component {
    
    let parent: RootComponent
    private let positionsRepository: PositionsRepository
    private let authenticationTokenRepository: AuthenticationTokenRepository
    
    private let networkClient: NetworkClient
    
    init(parent: RootComponent) {
        self.parent = parent
        authenticationTokenRepository = AuthenticationTokenRepositoryImpl()
        networkClient = NetworkClientImpl(
            session: .shared,
            requestSerializer: JSONRequestSerializer(),
            responseSerializer: JSONResponseSerializer(),
            endpointConfiguration: AuthenticationTokenEndpointConfigurationDecorator(
                configuration: EndpointConfigurationImpl(),
                authenticationTokenRepository: authenticationTokenRepository
            )
        )
        positionsRepository = PositionsRepositoryImpl(
            client: networkClient
        )
    }
    
    func makeSignUpNewUser() -> some View {
        let signUpNetworkClient = AuthenticationNetworkClientDecorator(
            client: AuthenticationNetworkClientDecorator(
                client: NetworkClientImpl(
                    session: .shared,
                    requestSerializer: MultipartFormDataRequestSerializer(
                        encoder: MultipartFormDataEncoderImpl()
                    ),
                    responseSerializer: JSONResponseSerializer(),
                    endpointConfiguration: AuthenticationTokenEndpointConfigurationDecorator(
                        configuration: EndpointConfigurationImpl(),
                        authenticationTokenRepository: authenticationTokenRepository
                    )
                ),
                authenticationTokenRepository: authenticationTokenRepository
            ),
            authenticationTokenRepository: authenticationTokenRepository
        )
        let viewModel = SignUpNewUserViewModel(
            signUp: SignUpImpl(
                client: signUpNetworkClient, 
                usersRepository: parent.usersRepository
            ),
            signUpFormValidator: SignUpFormValidatorImpl(
                phoneNumberService: PhoneNumberServiceImpl()
            ),
            positionsRepository: positionsRepository
        )
        return SignUpNewUserView(viewModel: viewModel)
    }
}
