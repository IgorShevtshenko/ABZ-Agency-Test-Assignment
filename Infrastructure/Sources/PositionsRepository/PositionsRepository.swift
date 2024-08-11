import Utils
import Domain

public enum PositionsRepositoryError: Error {
    case noInternetConnection
    case general
}

public protocol PositionsRepository {
    var positions: ProtectedPublisher<[Position]> { get }
    func fetchPositions() -> Completable<PositionsRepositoryError>
}
