import Foundation
import NetworkClient

public struct MultipartFormDataRequestSerializer: RequestSerializer {

    private let encoder: MultipartFormDataEncoder

    public init(encoder: MultipartFormDataEncoder) {
        self.encoder = encoder
    }

    public func encode(_ value: some Encodable) throws -> Data {
        try encoder.encode(value)
    }

    public func configureContentType(on urlRequest: URLRequest) -> URLRequest {
        var request = urlRequest
        request.setValue(
            "multipart/form-data; boundary=Boundary",
            forHTTPHeaderField: "Content-Type"
        )
        return request
    }
}
