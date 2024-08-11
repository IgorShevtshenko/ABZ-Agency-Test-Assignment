import UsersRepository
import NetworkClient

extension Error {
    
    var asUsersRepositoryError: UsersRepositoryError {
        switch self as? NetworkClientError {
        case .externalError(let error):
                .other(error)
        case .noInternetConnection:
                .noInternetConnection
        case .failedToGenerateURL,
                .invalidStatusCode,
                .none:
                .general
        }
    }
}
