import Foundation
import NetworkClient

public struct JSONResponseSerializer: ResponseSerializer {

    private let decoder = JSONDecoder()

    public init() {}

    public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        try decoder.decode(type, from: data)
    }
}
