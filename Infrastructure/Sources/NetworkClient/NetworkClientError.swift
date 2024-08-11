public enum NetworkClientError: Error {
    case failedToGenerateURL(String)
    case externalError(Error)
    case noInternetConnection
    case invalidStatusCode(Int)
}
