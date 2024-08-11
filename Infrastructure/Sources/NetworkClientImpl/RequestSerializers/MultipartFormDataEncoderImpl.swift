import Foundation
import NetworkClient

internal class MultipartFormDataEncoderImpl: MultipartFormDataEncoder {

    private let encoder = JSONEncoder()
    private let boundary = "Boundary"

    init() {
        encoder.dataEncodingStrategy = .deferredToData
    }

    func encode(_ value: some Encodable) throws -> Data {
        let data = try encoder.encode(value)
        let dict = try JSONSerialization.jsonObject(with: data, options: [])

        guard
            let dict = dict as? [String: Any]
        else {
            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(
                    codingPath: [],
                    debugDescription: "Encoded object is not [String: Any]"
                )
            )
        }

        let httpBody = NSMutableData()
        for (key, value) in dict {
            append(on: httpBody, key: key, value: value)
        }
        httpBody.appendString("--\(boundary)--")
        return httpBody as Data
    }

    private func append(on httpBody: NSMutableData, key: String, value: Any) {
        if let value = value as? String {
            httpBody.appendString(
                convertFormField(
                    named: key,
                    value: value,
                    using: boundary
                )
            )
        } else if let data = value as? [UInt8] {
            let data = Data(data)
            httpBody.append(
                convertFileData(
                    fieldName: key,
                    fileName: "fileName",
                    mimeType: data.mimeType,
                    fileData: data,
                    using: boundary
                )
            )
        } else if let arr = value as? [Any] {
            for value in arr {
                append(on: httpBody, key: key, value: value)
            }
        }
    }

    private func convertFormField(
        named name: String,
        value: String,
        using boundary: String
    ) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        return fieldString
    }

    func convertFileData(
        fieldName: String,
        fileName: String,
        mimeType: String,
        fileData: Data,
        using boundary: String
    ) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString(
            "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
        )
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        return data as Data
    }
}

private extension NSMutableData {

    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension Data {

    private static let mimeTypeSignatures: [UInt8: String] = [
        0xFF: "image/jpeg",
        
    ]

    var mimeType: String {
            var c: UInt8 = 0
            copyBytes(to: &c, count: 1)
            return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
        }
}
