import Foundation

public protocol RequestSerializer {
    func encode<T: Encodable>(_ value: T) throws -> Data
    func configureContentType(on urlRequest: URLRequest) -> URLRequest
}
