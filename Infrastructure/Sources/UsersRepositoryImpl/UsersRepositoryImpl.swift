import UsersRepository
import Combine
import Utils
import Domain
import Foundation
import NetworkClient

public final class UsersRepositoryImpl: UsersRepository {
    
    public var users: ProtectedPublisher<PaginatedArray<User>> {
        _users.eraseToAnyPublisher()
    }
    
    private let _users = CurrentValueSubject<PaginatedArray<User>, Never>(
        .init(elements: [], cursor: .page(1))
    )
    
    private let client: NetworkClient
    
    public init(client: NetworkClient) {
        self.client = client
    }
    
    public func fetchUsers() -> Completable<UsersRepositoryError> {
        fetchUsers(page: 1)
            .handleEvents(receiveOutput: { [_users] users in
                _users.send(users)
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    public func fetchMoreUsers() -> Completable<UsersRepositoryError> {
        let users = _users.value
        guard case .page(let page) = users.cursor else {
            return Empty().eraseToAnyPublisher()
        }
        return fetchUsers(page: page + 1)
            .map { paginatedArray in
                PaginatedArray(
                    elements: (users.elements + paginatedArray.elements),
                    cursor: paginatedArray.cursor
                )
            }
        //MARK: Delay is added to see loader 
            .delay(for: 1, scheduler: DispatchQueue.main)
            .handleEvents(receiveOutput: { [_users] users in
                _users.send(users)
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
    
    private func fetchUsers(page: Int) -> AnyPublisher<PaginatedArray<User>, UsersRepositoryError> {
        client.get(
            UserResponseEntity.self,
            path: "users",
            queryItems: [
                .init(name: "page", value: "\(page)"),
                .init(name: "count", value: "6")
            ]
        )
        .map(\.asPaginatedArray)
        .mapError(\.asUsersRepositoryError)
        .eraseToAnyPublisher()
    }
}

struct UserResponseEntity: Decodable {
    let page: Int
    let total_pages: Int
    let users: [UserEntity]
}

struct UserEntity: Decodable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let photo: String
    let position: String
    let registration_timestamp: Int
}
