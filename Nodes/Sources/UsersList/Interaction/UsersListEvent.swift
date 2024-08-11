import Domain
import GetUsers

enum UsersListEvent {
    case didFetchUsers([User])
    case didReceiveNoConnectionError
    case didChangeIsMoreUsersAvailable(Bool)
}
