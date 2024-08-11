import SignUp
import Domain
import Utils
import NetworkClient
import Combine
import Foundation

public struct SignUpImpl: SignUp {
    
    private let client: NetworkClient
    
    public init(client: NetworkClient) {
        self.client = client
    }
    
    public func callAsFunction(using form: SignUpForm) -> Completable<SignUpError> {
        getToken()
            .flatMap { token in
                client.post(
                    SignUpRequest(
                        name: form.name,
                        phone: form.phone,
                        email: form.email,
                        photo: form.photo,
                        position_id: form.position.id
                    ),
                    path: "users",
                    queryItems: [
                        .init(name: "Token", value: token)
                    ]
                )
                .mapError(\.asSignUpError)
            }
            .eraseToAnyPublisher()
    }
    
    private func getToken() -> AnyPublisher<String, SignUpError> {
        client.get(TokenResponse.self, path: "token")
            .map(\.token)
            .mapError(\.asSignUpError)
            .eraseToAnyPublisher()
    }
}

private struct TokenResponse: Decodable {
    let token: String
}

private struct SignUpRequest: Encodable {
    let name: String
    let phone: String
    let email: String
    let photo: Data
    let position_id: Int
}

private extension Error {
    
    var asSignUpError: SignUpError {
        switch self as? NetworkClientError {
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
