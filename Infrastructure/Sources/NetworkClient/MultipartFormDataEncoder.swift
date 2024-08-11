import Foundation

public protocol MultipartFormDataEncoder {
    func encode(_ value: some Encodable) throws -> Data
}
