import Domain
import Utils
import PositionsRepository
import NetworkClient
import Combine

public struct PositionsRepositoryImpl: PositionsRepository {
    
    public var positions: ProtectedPublisher<[Position]> {
        _positions.eraseToAnyPublisher()
    }
    
    private let _positions = CurrentValueSubject<[Position], Never>([])
    
    private let client: NetworkClient

    public init(client: NetworkClient) {
        self.client = client
    }
    
    public func fetchPositions() -> Completable<PositionsRepositoryError> {
        client.get(PositionsResponse.self, path: "positions")
            .map(\.positions)
            .map { $0.map(Position.init) }
            .mapError(\.asPositionsRepositoryError)
            .handleEvents(receiveOutput: { [_positions] positions in
                _positions.send(positions)
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
}

private struct PositionsResponse: Decodable {
    let positions: [PositionEntity]
}

private struct PositionEntity: Decodable {
    let id: Int
    let name: String
}

private extension Position {
    
    init(from entity: PositionEntity) {
        self = Position(id: entity.id, name: entity.name)
    }
}

private extension Error {
    
    var asPositionsRepositoryError: PositionsRepositoryError {
        switch self as? NetworkClientError {
        case .noInternetConnection:
                .noInternetConnection
        case .failedToGenerateURL,
                .invalidStatusCode,
                .externalError,
                .none:
                .general
        }
    }
}
