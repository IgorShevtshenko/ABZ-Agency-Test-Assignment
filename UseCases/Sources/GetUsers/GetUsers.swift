import Utils
import Domain

public enum GetUsersError: Error {
    case general
    case noInternetConnection
}

public protocol GetUsers {
    var users: ProtectedPublisher<[User]> { get }
    var isMoreAvailable: ProtectedPublisher<Bool> { get }
    func fetchUsers() -> Completable<GetUsersError>
    func fetchMoreUsers() -> Completable<GetUsersError>
}
