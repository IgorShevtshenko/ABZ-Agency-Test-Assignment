import Domain
import Utils
import PositionsRepository
import NetworkClient
import Combine

public struct PositionsRepositoryImpl: PositionsRepository {
    
    public var positions: ProtectedPublisher<[Positon]> {
        _positions.eraseToAnyPublisher()
    }
    
    private let _positions = CurrentValueSubject<[Positon], Never>([])
    
    private let client: NetworkClient

    public init(client: NetworkClient) {
        self.client = client
    }
    
    public func fetchPositions() -> Completable<PositionsRepositoryError> {
        client.get(PositionsResponse.self, path: "positions")
            .map(\.positions)
            .map { $0.map(Positon.init) }
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

private extension Positon {
    
    init(from entity: PositionEntity) {
        self = Positon(id: entity.id, name: entity.name)
    }
}

extension Error {
    
    var asPositionsRepositoryError: PositionsRepositoryError {
        switch self as? NetworkClientError {
        case .externalError(let error):
                .other(error)
        case .noInternetConnection:
                .noInternetConnection
        case .failedToGenerateURL,
                .invalidStatusCode,
                .none:
                .general
        }
    }
}
