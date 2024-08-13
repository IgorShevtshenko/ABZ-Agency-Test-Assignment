import Combine
import GetUsers
import Foundation
import Domain
import PhoneNumberService
import Utils
import Architecture

public final class UsersListViewModel: ViewModel<UsersListState, UsersListAction> {
    
    private let events = PassthroughSubject<UsersListEvent, Never>()
    
    private let getUsers: GetUsers
    private let phoneNumberService: PhoneNumberService
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(getUsers: GetUsers, phoneNumberService: PhoneNumberService) {
        self.getUsers = getUsers
        self.phoneNumberService = phoneNumberService
        
        let isMoreUsersAvailable = getUsers.isMoreAvailable
            .map(UsersListEvent.didChangeIsMoreUsersAvailable)
        
        super.init(
            initial: .init(),
            dataEvents: events.merge(with: isMoreUsersAvailable),
            reducer: Self.reduce
        )
        
        send(.fetchUsers)
    }
    
    private static func reduce(state: State, event: UsersListEvent) -> State {
        var state = state
        switch event {
        case .didFetchUsers(let users):
            let sortedUsers = users.sorted { lhs, rhs in
                lhs.registrationDate > rhs.registrationDate
            }
            state.state = users.isEmpty ? .empty : .success(sortedUsers)
        case .didReceiveNoConnectionError:
            state.state = .noInternetConnection
        case .didChangeIsMoreUsersAvailable(let isMoreAvailable):
            state.isMoreAvailable = isMoreAvailable
        }
        return state
    }
    
    public override func send(_ action: Action) {
        switch action {
        case .fetchUsers:
            let fetchUsers = getUsers.fetchUsers()
                .share()
            fetchUsers
                .setOutputType(to: UsersListEvent.self)
                .append(
                    getUsers.users
                        .map { [phoneNumberService] users in
                            users.map { User(from: $0, phoneNumberService: phoneNumberService) }
                        }
                        .map(UsersListEvent.didFetchUsers)
                        .setFailureType(to: GetUsersError.self)
                )
                .sink(receiveValue: events.send)
                .store(in: &cancellables)
            
            fetchUsers
                .setOutputType(to: UsersListEvent.self)
                .catch { error in
                    switch error {
                    case .noInternetConnection:
                        return Just(UsersListEvent.didReceiveNoConnectionError)
                            .eraseToAnyPublisher()
                    case .general:
                        return Empty().eraseToAnyPublisher()
                    }
                }
                .sink(receiveValue: events.send)
                .store(in: &cancellables)
        case .loadMore:
            getUsers.fetchMoreUsers()
                .setOutputType(to: UsersListEvent.self)
                .catch { error in
                    switch error {
                    case .noInternetConnection:
                        return Just(UsersListEvent.didReceiveNoConnectionError)
                            .eraseToAnyPublisher()
                    case .general:
                        return Empty().eraseToAnyPublisher()
                    }
                }
                .sink(receiveValue: events.send)
                .store(in: &cancellables)
        }
    }
}

private extension User {
    
    init(from user: User, phoneNumberService: PhoneNumberService) {
        guard let phoneNumber = phoneNumberService.getPhoneNumber(by: user.phone) else {
            self = user
            return
        }
        self = User(
            id: user.id,
            name: user.name,
            email: user.email,
            phone: phoneNumber.getFullPhoneNumber(),
            photoUrl: user.photoUrl,
            positionTitle: user.positionTitle,
            registrationDate: user.registrationDate
        )
    }
}
