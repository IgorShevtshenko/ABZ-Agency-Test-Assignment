import Foundation
import NetworkClient

public struct JSONRequestSerializer: RequestSerializer {

    private let encoder = JSONEncoder()

    public init() {}

    public func encode(_ value: some Encodable) throws -> Data {
        try encoder.encode(value)
    }

    public func configureContentType(on urlRequest: URLRequest) -> URLRequest {
        var request = urlRequest
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        return request
    }
}
