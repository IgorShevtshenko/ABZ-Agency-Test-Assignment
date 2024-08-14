import UsersRepository
import GetUsers
import Utils
import Domain

public struct GetUsersImpl: GetUsers {
    
    public var users: ProtectedPublisher<[User]> {
        usersRepository.users
            .map(\.elements)
            .eraseToAnyPublisher()
    }
    
    public var isMoreAvailable: ProtectedPublisher<Bool> {
        usersRepository.users
            .map(\.cursor)
            .map { $0 != .end }
            .eraseToAnyPublisher()
        
    }
    
    private let usersRepository: UsersRepository
    
    public init(usersRepository: UsersRepository) {
        self.usersRepository = usersRepository
    }
    
    public func fetchUsers() -> Completable<GetUsersError> {
        usersRepository.fetchUsers()
            .mapError(\.asGetUsersError)
            .eraseToAnyPublisher()
    }
    
    public func fetchMoreUsers() -> Completable<GetUsersError> {
        usersRepository.fetchMoreUsers()
            .mapError(\.asGetUsersError)
            .eraseToAnyPublisher()
    }
}

private extension UsersRepositoryError {
    
    var asGetUsersError: GetUsersError {
        switch self {
        case .general:
                .general
        case .noInternetConnection:
                .noInternetConnection
        }
    }
}
