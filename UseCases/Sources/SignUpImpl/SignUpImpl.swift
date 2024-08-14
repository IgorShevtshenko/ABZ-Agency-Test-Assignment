import SignUp
import Domain
import Utils
import NetworkClient
import Combine
import Foundation
import AuthenticationTokenRepository

public struct SignUpImpl: SignUp {
    
    private let client: NetworkClient
    
    public init(client: NetworkClient) {
        self.client = client
    }
    
    public func callAsFunction(using form: SignUpForm) -> Completable<SignUpError> {
        client.post(
            SignUpRequest(
                name: form.name,
                phone: form.phone,
                email: form.email,
                photo: form.photo,
                position_id: String(form.position.id)
            ),
            path: "users"
        )
        .mapError(\.asSignUpError)
        .eraseToAnyPublisher()
    }
}

private struct SignUpRequest: Encodable {
    let name: String
    let phone: String
    let email: String
    let photo: Data
    let position_id: String
}

private extension Error {
    
    var asSignUpError: SignUpError {
        switch self as? NetworkClientError {
        case .externalError(let code) where code == 409:
                .userAlreadyExists
        case .noInternetConnection:
                .noInternetConnection
        case .failedToGenerateURL,
                .invalidStatusCode,
                .externalError,
                .none:
                .general
        }
    }
}
