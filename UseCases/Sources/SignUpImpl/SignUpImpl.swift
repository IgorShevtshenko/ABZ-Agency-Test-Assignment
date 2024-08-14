import SignUp
import Domain
import Utils
import NetworkClient
import Combine
import UsersRepository
import Foundation

public struct SignUpImpl: SignUp {
    
    private let client: NetworkClient
    private let usersRepository: UsersRepository
    
    public init(client: NetworkClient, usersRepository: UsersRepository) {
        self.client = client
        self.usersRepository = usersRepository
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
        .append(
            usersRepository.fetchUsers()
                .mapError(\.asSignUpError)
        )
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

private extension UsersRepositoryError {
    
    var asSignUpError: SignUpError {
        switch self {
        case .noInternetConnection:
                .noInternetConnection
        case .general:
                .general
        }
    }
}
