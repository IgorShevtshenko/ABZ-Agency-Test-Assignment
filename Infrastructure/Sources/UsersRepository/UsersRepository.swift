import Combine
import Utils
import Domain

public enum UsersRepositoryError: Error {
    case other(Error)
    case noInternetConnection
    case general
}

public protocol UsersRepository {
    var users: ProtectedPublisher<PaginatedArray<User>> { get }
    func fetchUsers() -> Completable<UsersRepositoryError>
    func fetchMoreUsers() -> Completable<UsersRepositoryError>
}
