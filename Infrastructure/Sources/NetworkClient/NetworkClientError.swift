public enum NetworkClientError: Error {
    case failedToGenerateURL(String)
    case externalError(Int)
    case noInternetConnection
    case invalidStatusCode(Int)
}
