import Architecture
import SwiftUI
import SignUpNewUser
import NetworkClientImpl
import SignUpImpl
import PositionsRepository
import PositionsRepositoryImpl
import SignUpFormValidatorImpl
import PhoneNumberServiceImpl

struct SignUpNewUserComponent {
    
    private let positionsRepository: PositionsRepository
    
    init() {
        positionsRepository = PositionsRepositoryImpl(
            client: NetworkClientImpl(
                session: .shared,
            requestSerializer: JSONRequestSerializer(),
            responseSerializer: JSONResponseSerializer()
            )
        )
    }
    
    func makeSignUpNewUser() -> some View {
        let viewModel = SignUpNewUserViewModel(
            signUp: SignUpImpl(
                client: NetworkClientImpl(
                    session: .shared,
                    requestSerializer: MultipartFormDataRequestSerializer(
                        encoder: MultipartFormDataEncoderImpl()
                    ),
                    responseSerializer: JSONResponseSerializer()
                )
            ), 
            signUpFormValidator: SignUpFormValidatorImpl(
                phoneNumberService: PhoneNumberServiceImpl()
            ),
            positionsRepository: positionsRepository
        )
        return SignUpNewUserView(viewModel: viewModel)
    }
}
