import UsersRepository
import NetworkClient

extension Error {
    
    var asUsersRepositoryError: UsersRepositoryError {
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
