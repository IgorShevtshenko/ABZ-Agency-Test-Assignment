import Domain
import GetUsers

public struct UsersListState {
    var state: State = .empty
    var isMoreAvailable = false
}

extension UsersListState {
    
    enum State: Equatable {
        case success([User])
        case empty
        case noInternetConnection
    }
}
