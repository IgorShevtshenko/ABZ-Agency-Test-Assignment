import Utils
import Domain

public enum PositionsRepositoryError: Error {
    case other(Error)
    case noInternetConnection
    case general
}

public protocol PositionsRepository {
    var positions: ProtectedPublisher<[Positon]> { get }
    func fetchPositions() -> Completable<PositionsRepositoryError>
}
