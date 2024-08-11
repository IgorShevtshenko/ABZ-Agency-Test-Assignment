import Foundation

public protocol ResponseSerializer {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}
